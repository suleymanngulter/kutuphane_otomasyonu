import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kutuphane_otomasyonu/model/kitap.dart';
import 'package:kutuphane_otomasyonu/model/kitap_database_provider.dart';
import 'package:kutuphane_otomasyonu/core/constants/app_constants.dart';

class KitapDetay extends StatefulWidget {
  final KitapModel kitap;

  const KitapDetay({
    super.key,
    required this.kitap,
  });

  @override
  State<KitapDetay> createState() => _KitapDetayState();
}

class _KitapDetayState extends State<KitapDetay> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _codeController;
  late TextEditingController _imageController;
  late bool _stoktaMi;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.kitap.kitapAdi);
    _descriptionController = TextEditingController(
      text: widget.kitap.kitapAciklamasi ?? '',
    );
    _codeController = TextEditingController(
      text: widget.kitap.kitapKodu ?? '',
    );
    _imageController = TextEditingController(
      text: widget.kitap.kitapResmi ?? '',
    );
    _stoktaMi = widget.kitap.stoktaMi;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kitap adı boş olamaz'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = context.read<BookDatabaseProvider>();
    final updatedBook = widget.kitap.copyWith(
      kitapAdi: _titleController.text,
      kitapAciklamasi: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      kitapKodu: _codeController.text.isEmpty ? null : _codeController.text,
      kitapResmi: _imageController.text.isEmpty ? null : _imageController.text,
      stoktaMi: _stoktaMi,
    );

    final success = await provider.updateBook(updatedBook);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? AppConstants.successBookSaved
                : AppConstants.errorSaveFailed,
          ),
          backgroundColor:
              success ? AppConstants.successColor : AppConstants.errorColor,
        ),
      );
    }
  }

  Future<void> _delete() async {
    if (widget.kitap.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silinecek kitap bulunamadı'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kitap Sil'),
        content: Text(
          '${widget.kitap.kitapAdi} adlı kitabı silmek istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final provider = context.read<BookDatabaseProvider>();
      final success = await provider.deleteBook(widget.kitap.id!);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? AppConstants.successBookDeleted
                  : AppConstants.errorDeleteFailed,
            ),
            backgroundColor:
                success ? AppConstants.successColor : AppConstants.errorColor,
          ),
        );
      }
    }
  }

  Widget _buildBookImage() {
    final imageUrl = _imageController.text;
    
    if (imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 300,
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          height: 300,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 64),
        ),
      );
    }
    
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.book, size: 80, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitap Detayı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _delete,
            tooltip: 'Sil',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBookImage(),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Kitap Adı *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Kitap Kodu',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.qr_code),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'Resim URL',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
                hintText: 'https://example.com/image.jpg',
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Card(
              child: CheckboxListTile(
                title: const Text('Stokta Var'),
                value: _stoktaMi,
                onChanged: (value) {
                  setState(() {
                    _stoktaMi = value ?? true;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Kaydet'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
