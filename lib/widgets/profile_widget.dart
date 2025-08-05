import 'package:flutter/material.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final double size;
  final double borderRadius;
  final String fallbackAsset;

  const ProfileAvatarWidget({
    Key? key,
    this.avatarUrl,
    this.size = 56,
    this.borderRadius = 15,
    this.fallbackAsset = 'assets/icons/ic_avatar.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: (avatarUrl != null && avatarUrl!.isNotEmpty)
            ? Image.network(
                avatarUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    fallbackAsset,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: size,
                    height: size,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              )
            : Image.asset(
                fallbackAsset,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
