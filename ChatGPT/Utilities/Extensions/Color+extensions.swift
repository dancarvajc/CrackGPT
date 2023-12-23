//
//  Color+extensions.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 17-04-23.
//

import SwiftUI

public extension Color {
    internal init(hex: Int, alpha: Double = 1) {
        let components = (R: Double((hex >> 16) & 0xFF) / 255,
                          G: Double((hex >> 08) & 0xFF) / 255,
                          B: Double((hex >> 00) & 0xFF) / 255)
        self.init(.sRGB,
                  red: components.R,
                  green: components.G,
                  blue: components.B,
                  opacity: alpha)
    }

    static var Primary100: Color {
        .LightBlue100
    }

    static var Primary500: Color {
        .LightBlue500
    }

    static var Primary600: Color {
        .LightBlue600
    }

    static var Primary800: Color {
        .LightBlue800
    }

    static var Black: Color {
        Color(hex: 0x000000)
    }

    static var White: Color {
        Color(hex: 0xFFFFFF)
    }

    static var Rose50: Color {
        Color(hex: 0xFFF1F2)
    }

    static var Rose100: Color {
        Color(hex: 0xFFE4E6)
    }

    static var Rose200: Color {
        Color(hex: 0xFECDD3)
    }

    static var Rose300: Color {
        Color(hex: 0xFDA4AF)
    }

    static var Rose400: Color {
        Color(hex: 0xFB7185)
    }

    static var Rose500: Color {
        Color(hex: 0xF43F5E)
    }

    static var Rose600: Color {
        Color(hex: 0xE11D48)
    }

    static var Rose700: Color {
        Color(hex: 0xBE123C)
    }

    static var Rose800: Color {
        Color(hex: 0x9F1239)
    }

    static var Rose900: Color {
        Color(hex: 0x881337)
    }

    static var Pink50: Color {
        Color(hex: 0xFDF2F8)
    }

    static var Pink100: Color {
        Color(hex: 0xFCE7F3)
    }

    static var Pink200: Color {
        Color(hex: 0xFBCFE8)
    }

    static var Pink300: Color {
        Color(hex: 0xF9A8D4)
    }

    static var Pink400: Color {
        Color(hex: 0xF472B6)
    }

    static var Pink500: Color {
        Color(hex: 0xEC4899)
    }

    static var Pink600: Color {
        Color(hex: 0xDB2777)
    }

    static var Pink700: Color {
        Color(hex: 0xBE185D)
    }

    static var Pink800: Color {
        Color(hex: 0x9D174D)
    }

    static var Pink900: Color {
        Color(hex: 0x831843)
    }

    static var Fuchsia50: Color {
        Color(hex: 0xFDF4FF)
    }

    static var Fuchsia100: Color {
        Color(hex: 0xFAE8FF)
    }

    static var Fuchsia200: Color {
        Color(hex: 0xF5D0FE)
    }

    static var Fuchsia300: Color {
        Color(hex: 0xF0ABFC)
    }

    static var Fuchsia400: Color {
        Color(hex: 0xE879F9)
    }

    static var Fuchsia500: Color {
        Color(hex: 0xD946EF)
    }

    static var Fuchsia600: Color {
        Color(hex: 0xC026D3)
    }

    static var Fuchsia700: Color {
        Color(hex: 0xA21CAF)
    }

    static var Fuchsia800: Color {
        Color(hex: 0x86198F)
    }

    static var Fuchsia900: Color {
        Color(hex: 0x701A75)
    }

    static var Purple50: Color {
        Color(hex: 0xFAF5FF)
    }

    static var Purple100: Color {
        Color(hex: 0xF3E8FF)
    }

    static var Purple200: Color {
        Color(hex: 0xE9D5FF)
    }

    static var Purple300: Color {
        Color(hex: 0xD8B4FE)
    }

    static var Purple400: Color {
        Color(hex: 0xC084FC)
    }

    static var Purple500: Color {
        Color(hex: 0xA855F7)
    }

    static var Purple600: Color {
        Color(hex: 0x9333EA)
    }

    static var Purple700: Color {
        Color(hex: 0x7E22CE)
    }

    static var Purple800: Color {
        Color(hex: 0x6B21A8)
    }

    static var Purple900: Color {
        Color(hex: 0x581C87)
    }

    static var Violet50: Color {
        Color(hex: 0xF5F3FF)
    }

    static var Violet100: Color {
        Color(hex: 0xEDE9FE)
    }

    static var Violet200: Color {
        Color(hex: 0xDDD6FE)
    }

    static var Violet300: Color {
        Color(hex: 0xC4B5FD)
    }

    static var Violet400: Color {
        Color(hex: 0xA78BFA)
    }

    static var Violet500: Color {
        Color(hex: 0x8B5CF6)
    }

    static var Violet600: Color {
        Color(hex: 0x7C3AED)
    }

    static var Violet700: Color {
        Color(hex: 0x6D28D9)
    }

    static var Violet800: Color {
        Color(hex: 0x5B21B6)
    }

    static var Violet900: Color {
        Color(hex: 0x4C1D95)
    }

    static var Indigo50: Color {
        Color(hex: 0xEEF2FF)
    }

    static var Indigo100: Color {
        Color(hex: 0xE0E7FF)
    }

    static var Indigo200: Color {
        Color(hex: 0xC7D2FE)
    }

    static var Indigo300: Color {
        Color(hex: 0xA5B4FC)
    }

    static var Indigo400: Color {
        Color(hex: 0x818CF8)
    }

    static var Indigo500: Color {
        Color(hex: 0x6366F1)
    }

    static var Indigo600: Color {
        Color(hex: 0x4F46E5)
    }

    static var Indigo700: Color {
        Color(hex: 0x4338CA)
    }

    static var Indigo800: Color {
        Color(hex: 0x3730A3)
    }

    static var Indigo900: Color {
        Color(hex: 0x312E81)
    }

    static var Blue50: Color {
        Color(hex: 0xEFF6FF)
    }

    static var Blue100: Color {
        Color(hex: 0xDBEAFE)
    }

    static var Blue200: Color {
        Color(hex: 0xBFDBFE)
    }

    static var Blue300: Color {
        Color(hex: 0x93C5FD)
    }

    static var Blue400: Color {
        Color(hex: 0x60A5FA)
    }

    static var Blue500: Color {
        Color(hex: 0x3B82F6)
    }

    static var Blue600: Color {
        Color(hex: 0x2563EB)
    }

    static var Blue700: Color {
        Color(hex: 0x1D4ED8)
    }

    static var Blue800: Color {
        Color(hex: 0x1E40AF)
    }

    static var Blue900: Color {
        Color(hex: 0x1E3A8A)
    }

    static var LightBlue50: Color {
        Color(hex: 0xF0F9FF)
    }

    static var LightBlue100: Color {
        Color(hex: 0xE0F2FE)
    }

    static var LightBlue200: Color {
        Color(hex: 0xBAE6FD)
    }

    static var LightBlue300: Color {
        Color(hex: 0x7DD3FC)
    }

    static var LightBlue400: Color {
        Color(hex: 0x38BDF8)
    }

    static var LightBlue500: Color {
        Color(hex: 0x0EA5E9)
    }

    static var LightBlue600: Color {
        Color(hex: 0x0284C7)
    }

    static var LightBlue700: Color {
        Color(hex: 0x0369A1)
    }

    static var LightBlue800: Color {
        Color(hex: 0x075985)
    }

    static var LightBlue900: Color {
        Color(hex: 0x0C4A6E)
    }

    static var Cyan50: Color {
        Color(hex: 0xECFEFF)
    }

    static var Cyan100: Color {
        Color(hex: 0xCFFAFE)
    }

    static var Cyan200: Color {
        Color(hex: 0xA5F3FC)
    }

    static var Cyan300: Color {
        Color(hex: 0x67E8F9)
    }

    static var Cyan400: Color {
        Color(hex: 0x22D3EE)
    }

    static var Cyan500: Color {
        Color(hex: 0x06B6D4)
    }

    static var Cyan600: Color {
        Color(hex: 0x0891B2)
    }

    static var Cyan700: Color {
        Color(hex: 0x0E7490)
    }

    static var Cyan800: Color {
        Color(hex: 0x155E75)
    }

    static var Cyan900: Color {
        Color(hex: 0x164E63)
    }

    static var Teal50: Color {
        Color(hex: 0xF0FDFA)
    }

    static var Teal100: Color {
        Color(hex: 0xCCFBF1)
    }

    static var Teal200: Color {
        Color(hex: 0x99F6E4)
    }

    static var Teal300: Color {
        Color(hex: 0x5EEAD4)
    }

    static var Teal400: Color {
        Color(hex: 0x2DD4BF)
    }

    static var Teal500: Color {
        Color(hex: 0x14B8A6)
    }

    static var Teal600: Color {
        Color(hex: 0x0D9488)
    }

    static var Teal700: Color {
        Color(hex: 0x0F766E)
    }

    static var Teal800: Color {
        Color(hex: 0x115E59)
    }

    static var Teal900: Color {
        Color(hex: 0x134E4A)
    }

    static var Emerald50: Color {
        Color(hex: 0xECFDF5)
    }

    static var Emerald100: Color {
        Color(hex: 0xD1FAE5)
    }

    static var Emerald200: Color {
        Color(hex: 0xA7F3D0)
    }

    static var Emerald300: Color {
        Color(hex: 0x6EE7B7)
    }

    static var Emerald400: Color {
        Color(hex: 0x34D399)
    }

    static var Emerald500: Color {
        Color(hex: 0x10B981)
    }

    static var Emerald600: Color {
        Color(hex: 0x059669)
    }

    static var Emerald700: Color {
        Color(hex: 0x047857)
    }

    static var Emerald800: Color {
        Color(hex: 0x065F46)
    }

    static var Emerald900: Color {
        Color(hex: 0x064E3B)
    }

    static var Green50: Color {
        Color(hex: 0xF0FDF4)
    }

    static var Green100: Color {
        Color(hex: 0xDCFCE7)
    }

    static var Green200: Color {
        Color(hex: 0xBBF7D0)
    }

    static var Green300: Color {
        Color(hex: 0x86EFAC)
    }

    static var Green400: Color {
        Color(hex: 0x4ADE80)
    }

    static var Green500: Color {
        Color(hex: 0x22C55E)
    }

    static var Green600: Color {
        Color(hex: 0x16A34A)
    }

    static var Green700: Color {
        Color(hex: 0x15803D)
    }

    static var Green800: Color {
        Color(hex: 0x166534)
    }

    static var Green900: Color {
        Color(hex: 0x14532D)
    }

    static var Lime50: Color {
        Color(hex: 0xF7FEE7)
    }

    static var Lime100: Color {
        Color(hex: 0xECFCCB)
    }

    static var Lime200: Color {
        Color(hex: 0xD9F99D)
    }

    static var Lime300: Color {
        Color(hex: 0xBEF264)
    }

    static var Lime400: Color {
        Color(hex: 0xA3E635)
    }

    static var Lime500: Color {
        Color(hex: 0x84CC16)
    }

    static var Lime600: Color {
        Color(hex: 0x65A30D)
    }

    static var Lime700: Color {
        Color(hex: 0x4D7C0F)
    }

    static var Lime800: Color {
        Color(hex: 0x3F6212)
    }

    static var Lime900: Color {
        Color(hex: 0x365314)
    }

    static var Yellow50: Color {
        Color(hex: 0xFEFCE8)
    }

    static var Yellow100: Color {
        Color(hex: 0xFEF9C3)
    }

    static var Yellow200: Color {
        Color(hex: 0xFEF08A)
    }

    static var Yellow300: Color {
        Color(hex: 0xFDE047)
    }

    static var Yellow400: Color {
        Color(hex: 0xFACC15)
    }

    static var Yellow500: Color {
        Color(hex: 0xEAB308)
    }

    static var Yellow600: Color {
        Color(hex: 0xCA8A04)
    }

    static var Yellow700: Color {
        Color(hex: 0xA16207)
    }

    static var Yellow800: Color {
        Color(hex: 0x854D0E)
    }

    static var Yellow900: Color {
        Color(hex: 0x713F12)
    }

    static var Amber50: Color {
        Color(hex: 0xFFFBEB)
    }

    static var Amber100: Color {
        Color(hex: 0xFEF3C7)
    }

    static var Amber200: Color {
        Color(hex: 0xFDE68A)
    }

    static var Amber300: Color {
        Color(hex: 0xFCD34D)
    }

    static var Amber400: Color {
        Color(hex: 0xFBBF24)
    }

    static var Amber500: Color {
        Color(hex: 0xF59E0B)
    }

    static var Amber600: Color {
        Color(hex: 0xD97706)
    }

    static var Amber700: Color {
        Color(hex: 0xB45309)
    }

    static var Amber800: Color {
        Color(hex: 0x92400E)
    }

    static var Amber900: Color {
        Color(hex: 0x78350F)
    }

    static var Orange50: Color {
        Color(hex: 0xFFF7ED)
    }

    static var Orange100: Color {
        Color(hex: 0xFFEDD5)
    }

    static var Orange200: Color {
        Color(hex: 0xFED7AA)
    }

    static var Orange300: Color {
        Color(hex: 0xFDBA74)
    }

    static var Orange400: Color {
        Color(hex: 0xFB923C)
    }

    static var Orange500: Color {
        Color(hex: 0xF97316)
    }

    static var Orange600: Color {
        Color(hex: 0xEA580C)
    }

    static var Orange700: Color {
        Color(hex: 0xC2410C)
    }

    static var Orange800: Color {
        Color(hex: 0x9A3412)
    }

    static var Orange900: Color {
        Color(hex: 0x7C2D12)
    }

    static var Red50: Color {
        Color(hex: 0xFEF2F2)
    }

    static var Red100: Color {
        Color(hex: 0xFEE2E2)
    }

    static var Red200: Color {
        Color(hex: 0xFECACA)
    }

    static var Red300: Color {
        Color(hex: 0xFCA5A5)
    }

    static var Red400: Color {
        Color(hex: 0xF87171)
    }

    static var Red500: Color {
        Color(hex: 0xEF4444)
    }

    static var Red600: Color {
        Color(hex: 0xDC2626)
    }

    static var Red700: Color {
        Color(hex: 0xB91C1C)
    }

    static var Red800: Color {
        Color(hex: 0x991B1B)
    }

    static var Red900: Color {
        Color(hex: 0x7F1D1D)
    }

    static var WarmGray50: Color {
        Color(hex: 0xFAFAF9)
    }

    static var WarmGray100: Color {
        Color(hex: 0xF5F5F4)
    }

    static var WarmGray200: Color {
        Color(hex: 0xE7E5E4)
    }

    static var WarmGray300: Color {
        Color(hex: 0xD6D3D1)
    }

    static var WarmGray400: Color {
        Color(hex: 0xA8A29E)
    }

    static var WarmGray500: Color {
        Color(hex: 0x78716C)
    }

    static var WarmGray600: Color {
        Color(hex: 0x57534E)
    }

    static var WarmGray700: Color {
        Color(hex: 0x44403C)
    }

    static var WarmGray800: Color {
        Color(hex: 0x292524)
    }

    static var WarmGray900: Color {
        Color(hex: 0x1C1917)
    }

    static var TrueGray50: Color {
        Color(hex: 0xFAFAFA)
    }

    static var TrueGray100: Color {
        Color(hex: 0xF5F5F5)
    }

    static var TrueGray200: Color {
        Color(hex: 0xE5E5E5)
    }

    static var TrueGray300: Color {
        Color(hex: 0xD4D4D4)
    }

    static var TrueGray400: Color {
        Color(hex: 0xA3A3A3)
    }

    static var TrueGray500: Color {
        Color(hex: 0x737373)
    }

    static var TrueGray600: Color {
        Color(hex: 0x525252)
    }

    static var TrueGray700: Color {
        Color(hex: 0x404040)
    }

    static var TrueGray800: Color {
        Color(hex: 0x262626)
    }

    static var TrueGray900: Color {
        Color(hex: 0x171717)
    }

    static var Gray50: Color {
        Color(hex: 0xFAFAFA)
    }

    static var Gray100: Color {
        Color(hex: 0xF4F4F5)
    }

    static var Gray200: Color {
        Color(hex: 0xE4E4E7)
    }

    static var Gray300: Color {
        Color(hex: 0xD4D4D8)
    }

    static var Gray400: Color {
        Color(hex: 0xA1A1AA)
    }

    static var Gray500: Color {
        Color(hex: 0x71717A)
    }

    static var Gray600: Color {
        Color(hex: 0x52525B)
    }

    static var Gray700: Color {
        Color(hex: 0x3F3F46)
    }

    static var Gray800: Color {
        Color(hex: 0x27272A)
    }

    static var Gray900: Color {
        Color(hex: 0x18181B)
    }

    static var CoolGray50: Color {
        Color(hex: 0xF9FAFB)
    }

    static var CoolGray100: Color {
        Color(hex: 0xF3F4F6)
    }

    static var CoolGray200: Color {
        Color(hex: 0xE5E7EB)
    }

    static var CoolGray300: Color {
        Color(hex: 0xD1D5DB)
    }

    static var CoolGray400: Color {
        Color(hex: 0x9CA3AF)
    }

    static var CoolGray500: Color {
        Color(hex: 0x6B7280)
    }

    static var CoolGray600: Color {
        Color(hex: 0x4B5563)
    }

    static var CoolGray700: Color {
        Color(hex: 0x374151)
    }

    static var CoolGray800: Color {
        Color(hex: 0x1F2937)
    }

    static var CoolGray900: Color {
        Color(hex: 0x111827)
    }

    static var BlueGray50: Color {
        Color(hex: 0xF8FAFC)
    }

    static var BlueGray100: Color {
        Color(hex: 0xF1F5F9)
    }

    static var BlueGray200: Color {
        Color(hex: 0xE2E8F0)
    }

    static var BlueGray300: Color {
        Color(hex: 0xCBD5E1)
    }

    static var BlueGray400: Color {
        Color(hex: 0x94A3B8)
    }

    static var BlueGray500: Color {
        Color(hex: 0x64748B)
    }

    static var BlueGray600: Color {
        Color(hex: 0x475569)
    }

    static var BlueGray700: Color {
        Color(hex: 0x334155)
    }

    static var BlueGray800: Color {
        Color(hex: 0x1E293B)
    }

    static var BlueGray900: Color {
        Color(hex: 0x0F172A)
    }
}
