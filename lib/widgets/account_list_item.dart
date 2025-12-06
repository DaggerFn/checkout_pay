import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class AccountListItem extends StatelessWidget {
  final String name;
  final String value;
  final String date;
  final String? time;
  final String status; // "Pendente", "Vencida", "Pago"
  final VoidCallback? onTap;

  const AccountListItem({
    super.key,
    required this.name,
    required this.value,
    required this.date,
    this.time,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color itemColor;
    IconData itemIcon;
    bool isStrikethrough = false;

    if (status == 'Vencida') {
      itemColor = AppColors.dangerColor;
      itemIcon = Icons.cancel;
      isStrikethrough = true;
    } else if (status == 'Pendente') {
      itemColor = AppColors.warningColor;
      itemIcon = Icons.check_box_outline_blank;
    } else {
      // Pago
      itemColor = AppColors.successColor;
      itemIcon = Icons.check_box;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: itemColor.withAlpha((0.7 * 255).round()),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(itemIcon, color: itemColor, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColorLight,
                        decoration: isStrikethrough
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: itemColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vencimento: $date ${time != null ? 'às $time' : ''}',
                      style: TextStyle(
                        color: AppColors.textColorLight.withAlpha(
                          (0.7 * 255).round(),
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: itemColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}