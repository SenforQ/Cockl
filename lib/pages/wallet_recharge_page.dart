import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../data/fitness_repository.dart';

class WalletRechargePage extends StatefulWidget {
  const WalletRechargePage({super.key, required this.repository});

  final FitnessRepository repository;

  static const List<WalletCoinProduct> products = [
    WalletCoinProduct(productId: 'Coin_Cockl_0', coins: 32, price: 0.99, priceText: '\$0.99'),
    WalletCoinProduct(productId: 'Coin_Cockl_1', coins: 60, price: 1.99, priceText: '\$1.99'),
    WalletCoinProduct(productId: 'Coin_Cockl_2', coins: 96, price: 2.99, priceText: '\$2.99'),
    WalletCoinProduct(productId: 'Coin_Cockl_4', coins: 155, price: 4.99, priceText: '\$4.99'),
    WalletCoinProduct(productId: 'Coin_Cockl_5', coins: 189, price: 5.99, priceText: '\$5.99'),
    WalletCoinProduct(productId: 'Coin_Cockl_9', coins: 359, price: 9.99, priceText: '\$9.99'),
    WalletCoinProduct(productId: 'Coin_Cockl_19', coins: 729, price: 19.99, priceText: '\$19.99'),
    WalletCoinProduct(productId: 'Coin_Cockl_49', coins: 1869, price: 49.99, priceText: '\$49.99'),
    WalletCoinProduct(productId: 'Coin_Cockl_99', coins: 3799, price: 99.99, priceText: '\$99.99'),
  ];

  @override
  State<WalletRechargePage> createState() => _WalletRechargePageState();

}

class _WalletRechargePageState extends State<WalletRechargePage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final Map<String, ProductDetails> _productsById = {};

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  bool _storeAvailable = false;
  bool _loadingProducts = true;
  String? _pendingProductId;

  @override
  void initState() {
    super.initState();
    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () {
        _purchaseSubscription?.cancel();
      },
      onError: (Object error) {
        if (!mounted) {
          return;
        }
        setState(() {
          _pendingProductId = null;
        });
      },
    );
    _initializeStore();
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeStore() async {
    setState(() {
      _loadingProducts = true;
    });
    final available = await _inAppPurchase.isAvailable();
    if (!mounted) {
      return;
    }
    if (!available) {
      setState(() {
        _storeAvailable = false;
        _loadingProducts = false;
      });
      return;
    }

    final ids = WalletRechargePage.products.map((e) => e.productId).toSet();
    final response = await _inAppPurchase.queryProductDetails(ids);
    if (!mounted) {
      return;
    }
    if (response.error != null) {
      setState(() {
        _storeAvailable = true;
        _loadingProducts = false;
      });
      return;
    }

    _productsById
      ..clear()
      ..addEntries(response.productDetails.map((e) => MapEntry(e.id, e)));
    setState(() {
      _storeAvailable = true;
      _loadingProducts = false;
    });
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        if (!mounted) {
          continue;
        }
        setState(() {
          _pendingProductId = purchase.productID;
        });
        continue;
      }

      if (purchase.status == PurchaseStatus.error) {
        if (!mounted) {
          continue;
        }
        setState(() {
          _pendingProductId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase failed: ${purchase.error?.message ?? 'Unknown error'}')),
        );
      }

      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        final product = WalletRechargePage.products
            .where((e) => e.productId == purchase.productID)
            .cast<WalletCoinProduct?>()
            .firstWhere((e) => e != null, orElse: () => null);
        if (product != null) {
          final alreadyDone = widget.repository.isWalletPurchaseProcessed(purchase.purchaseID ?? '');
          if (!alreadyDone) {
            await widget.repository.addWalletCoins(product.coins);
            await widget.repository.markWalletPurchaseProcessed(purchase.purchaseID ?? '');
            if (!mounted) {
              continue;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Recharge success +${product.coins} Coins')),
            );
          }
        }
      }

      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
      }
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _pendingProductId = null;
    });
  }

  Future<void> _buy(WalletCoinProduct product) async {
    if (!_storeAvailable || _pendingProductId != null) {
      return;
    }
    final details = _productsById[product.productId];
    if (details == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product not available: ${product.productId}')),
      );
      return;
    }
    final param = PurchaseParam(productDetails: details);
    setState(() {
      _pendingProductId = product.productId;
    });
    try {
      final launched = await _inAppPurchase.buyConsumable(purchaseParam: param);
      if (!launched && mounted) {
        setState(() {
          _pendingProductId = null;
        });
      }
    } on PlatformException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _pendingProductId = null;
      });
      if (e.code != 'storekit2_purchase_cancelled' && e.code != 'purchase_cancelled') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase failed: ${e.message ?? e.code}')),
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _pendingProductId = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase failed: $e')),
      );
    }
  }

  Future<void> _showUsageRules() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Coins Usage Rules'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. After 7 plans, each extra plan costs 20 Coins'),
              SizedBox(height: 8),
              Text('2. Each AI conversation costs 1 Coin'),
              SizedBox(height: 8),
              Text('3. Completing training grants 5 Coins, max 5 Coins per day'),
              SizedBox(height: 8),
              Text('4. More than 10 consecutive check-in days grants 50 Coins'),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Recharge'),
        actions: [
          IconButton(
            tooltip: 'Coins usage rules',
            onPressed: _showUsageRules,
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: widget.repository,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Current Balance',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        '${widget.repository.walletCoins} Coins',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
              if (_loadingProducts)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              const SizedBox(height: 12),
              ...WalletRechargePage.products.map((product) {
                final pd = _productsById[product.productId];
                final priceText = pd?.price ?? product.priceText;
                final purchasing = _pendingProductId == product.productId;
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.14),
                      child: Icon(
                        Icons.monetization_on_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text('${product.coins} Coins'),
                    subtitle: Text(priceText),
                    trailing: FilledButton(
                      onPressed: (!_storeAvailable || _loadingProducts || purchasing || _pendingProductId != null)
                          ? null
                          : () => _buy(product),
                      child: purchasing
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Buy'),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class WalletCoinProduct {
  const WalletCoinProduct({
    required this.productId,
    required this.coins,
    required this.price,
    required this.priceText,
  });

  final String productId;
  final int coins;
  final double price;
  final String priceText;
}
