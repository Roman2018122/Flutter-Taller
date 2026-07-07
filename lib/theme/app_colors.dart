// lib/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // ── Fondos (Estilo Acero Oscuro / Asfalto) ──────────────────
  static const Color background = Color(0xFF0F1115); // Gris carbón muy oscuro
  static const Color surface = Color(0xFF171A21); // Gris metalizado mate
  static const Color surface2 = Color(0xFF21252D); // Gris de elevador mecánico
  static const Color border = Color(0xFF2D333F); // Bordes metálicos oscuros
  static const Color borderLight = Color(0xFF1F242E);

  // ── Texto ─────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF3F4F6); // Blanco titanio limpio
  static const Color textSecondary = Color(
    0xFF9CA3AF,
  ); // Gris aluminio para datos
  static const Color textFaint = Color(
    0xFF4B5563,
  ); // Gris grasa/aceite para pistas

  // ── Accent Naranja Industrial ──────────────────────────────
  static const Color accent = Color(
    0xFFF97316,
  ); // Naranja mecánico de alta visibilidad
  static const Color accentLight = Color(
    0xFFFB923C,
  ); // Naranja brillante para estados activos
  static const Color accentDark = Color(
    0xFFEA580C,
  ); // Naranja óxido/oscuro para presionar botones
  static const Color onAccent = Color(
    0xFF0F1115,
  ); // Texto oscuro sobre el fondo naranja

  // ── Semánticos ────────────────────────────────────────────
  static const Color success = Color(
    0xFF10B981,
  ); // Verde: Sistema operativo correcto
  static const Color warning = Color(
    0xFFF59E0B,
  ); // Amarillo: Alerta de mantenimiento
  static const Color error = Color(0xFFEF4444); // Rojo: Falla mecánica crítica
  static const Color info = Color(
    0xFF06B6D4,
  ); // Cian: Información técnica de diagnóstico

  // ── Estado de la Orden de Reparación (Taller) ──────────────
  static const Color statusPending = Color(
    0xFFF59E0B,
  ); // Ambar: Cita agendada / En espera de ingreso
  static const Color statusInProcess = Color(
    0xFF3B82F6,
  ); // Azul: El auto está en el elevador / Con el mecánico
  static const Color statusReady = Color(
    0xFF10B981,
  ); // Verde: Reparación finalizada / Listo para retiro
  static const Color statusDelivered = Color(
    0xFF6B7280,
  ); // Gris: Vehículo entregado al cliente
  static const Color statusCancelled = Color(
    0xFFEF4444,
  ); // Rojo: Cita o reparación cancelada

  AppColors._();
}
