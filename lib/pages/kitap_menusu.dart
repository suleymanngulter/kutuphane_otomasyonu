import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kutuphane_otomasyonu/model/kitap.dart';
import 'package:kutuphane_otomasyonu/pages/kitap_detay.dart';
import 'package:kutuphane_otomasyonu/core/constants/app_constants.dart';

class KitapMenusu extends StatelessWidget {
  final KitapModel kitap;

  const KitapMenusu({
    super.key,
    required this.kitap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KitapDetay(kitap: kitap),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildBookImage(),
              ),
              const SizedBox(width: 16),
              // Book Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            kitap.kitapAdi,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (kitap.stoktaMi)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Stokta',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Stokta Yok',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (kitap.kitapKodu != null && kitap.kitapKodu!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Kod: ${kitap.kitapKodu}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    if (kitap.kitapAciklamasi != null &&
                        kitap.kitapAciklamasi!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          kitap.kitapAciklamasi!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookImage() {
    if (kitap.kitapResmi != null && kitap.kitapResmi!.isNotEmpty) {
      // Check if it's a network URL
      if (kitap.kitapResmi!.startsWith('http://') ||
          kitap.kitapResmi!.startsWith('https://')) {
        return CachedNetworkImage(
          imageUrl: kitap.kitapResmi!,
          width: 80,
          height: 120,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 80,
            height: 120,
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => _buildDefaultImage(),
        );
      } else {
        // Local file path (not implemented in this version, use default)
        return _buildDefaultImage();
      }
    }
    return _buildDefaultImage();
  }

  Widget _buildDefaultImage() {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.book,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}
