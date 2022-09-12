import 'package:cypto_app/blocs/crypto/crypto_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Crypto Watcher'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              children: const [
                Text(
                  'Top 25',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 0,
                  thickness: 2,
                  color: Colors.white54,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Colors.black,
                  ],
                ),
              ),
              child: BlocBuilder<CryptoBloc, CryptoState>(
                builder: (context, state) {
                  switch (state.status) {
                    case Status.loaded:
                      return RefreshIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                        onRefresh: () async {
                          context.read<CryptoBloc>().add(RefreshCoins());
                        },
                        child: ListView.builder(
                          itemCount: state.coins.length,
                          itemBuilder: ((context, index) {
                            final coin = state.coins[index];
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: Text(coin.fullName,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      )),
                                  subtitle: Text(
                                    coin.name,
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  trailing: Text(
                                    coin.price.toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                                const Divider(),
                              ],
                            );
                          }),
                        ),
                      );
                    case Status.error:
                      return Center(
                        child: Text(
                          state.onError.message,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      );
                    default:
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
