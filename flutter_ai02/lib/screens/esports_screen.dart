import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EsportsScreen extends StatelessWidget {
  const EsportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // T1 우승 축하 배너 추가
    final worldsChampion = {
      'image': 'https://images.contentstack.io/v3/assets/blt731acb42bb3d1659/blt9313c8f3c4b13d0f/6557171123b6c04a9d58a3d1/T1_Worlds_2023.jpg',
      'title': 'T1 월드 챔피언십 우승',
      'description': '페이커와 T1, 2023 롤드컵 우승으로 새로운 역사를 써내다!',
    };

    final games = [
      {
        'title': 'League of Legends',
        'image': 'https://www.leagueoflegends.com/static/hero-0632cbf2872c5cc0dffa93d2ae8a29e8.jpg',
        'description': '세계적으로 가장 인기있는 MOBA 게임',
      },
      {
        'title': 'StarCraft',
        'image': 'https://bnetcmsus-a.akamaihd.net/cms/page_media/FXDOF10R780H1508961000011.jpg',
        'description': '스타크래프트: 브루드워, e스포츠의 전설',
      },
      {
        'title': 'Diablo IV',
        'image': 'https://cdn.cloudflare.steamstatic.com/steam/apps/2344520/header.jpg',
        'description': '액션 RPG의 대명사',
      },
      {
        'title': 'Overwatch 2',
        'image': 'https://cdn.akamai.steamstatic.com/steam/apps/2357570/header.jpg',
        'description': '차세대 팀 기반 액션 게임',
      },
      {
        'title': 'Rainbow Six Siege',
        'image': 'https://cdn.cloudflare.steamstatic.com/steam/apps/359550/header.jpg',
        'description': '전술적 팀 기반 FPS',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('e스포츠관'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 우승 축하 배너
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: worldsChampion['image']!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(179),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worldsChampion['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        worldsChampion['description']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 기존 게임 목록
          ...games.map((game) => Card(
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: game['image']!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 32),
                          const SizedBox(height: 8),
                          Text(game['title']!),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game['title']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        game['description']!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${game['title']} 상세 정보를 준비 중입니다.'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('자세히 보기'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
} 