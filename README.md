# GypsArt 🎨

A beautiful Flutter app for calculating clay sculpting ingredients with an Apple-inspired design. Perfect for artists working with gypsum, microcement, and candle making.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Material Design](https://img.shields.io/badge/Material%20Design-757575?style=for-the-badge&logo=material-design&logoColor=white)

## ✨ Features

### 🏗️ **Mold Management**
- **Dual Categories**: Separate sections for Gypsum forms and Candle molds
- **Visual Catalog**: High-quality images loaded from URLs
- **Smart Filtering**: Filter by categories (Вазы, Свечи, Скульптуры, Подносы, Формы)
- **Advanced Search**: Search by name or category with real-time results
- **Volume Display**: Clear volume indicators for each mold

### 🧮 **Ingredient Calculator**
- **Precise Calculations**: Automatic ingredient calculations based on mold volume
- **Multiple Gypsum Types**: Support for different gypsum varieties
- **Solution Options**: Various solution types (microcement, water, acrylic)
- **Colorant Control**: Adjustable colorant percentages (1-5%)
- **Predefined Values**: CSV-based predefined settings for optimal results

### 🎨 **Beautiful Design**
- **Apple-Inspired UI**: Liquid Glass design language with translucent materials
- **System Colors**: Native iOS color palette (#007AFF, #8E8E93, #F2F2F7)
- **Smooth Animations**: 60fps animations with proper easing curves
- **Responsive Layout**: Optimized for different screen sizes
- **Loading States**: Elegant loading indicators and error handling

### 📊 **Data Features**
- **CSV Integration**: Dynamic data loading from CSV files
- **Real-time Updates**: Instant filtering and search results
- **Smart Parsing**: Robust CSV parsing with error handling
- **Multilingual**: Russian interface with proper typography

## 🏗️ Architecture

Built with **Clean Architecture** principles:

```
├── presentation/     # UI Layer (Widgets, Screens, Providers)
│   ├── screens/     # Main app screens
│   ├── widgets/     # Reusable UI components
│   └── providers/   # Riverpod state management
├── domain/          # Business Logic (Entities, Repositories)
│   ├── entities/    # Core business objects
│   └── repositories/# Abstract repository interfaces
└── data/           # Data Layer (Services, Repository Implementations)
    ├── models/     # Data transfer objects
    ├── repositories/# Concrete repository implementations
    └── services/   # External service integrations
```

### 🛠️ **Tech Stack**
- **Framework**: Flutter 3.27.3
- **State Management**: Riverpod
- **Architecture**: Clean Architecture
- **Design**: Apple Human Interface Guidelines
- **Data**: CSV parsing with custom service layer

## 🚀 Installation

### **Prerequisites**
- Flutter SDK 3.27.3 or higher
- Dart SDK 3.6.1 or higher
- iOS Simulator / Android Emulator or physical device

### **Setup**
1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/gypsart.git
   cd gypsart
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Usage

### **Browsing Molds**
1. **Switch Categories**: Use the segmented control to switch between "Gypsum" and "Candles"
2. **Filter by Type**: Tap category chips to filter by specific types (Вазы, Свечи, etc.)
3. **Search**: Use the search bar to find specific molds by name
4. **View Details**: Tap any mold card to view calculation screen

### **Calculating Ingredients**
1. **Select Mold**: Choose your desired mold from the catalog
2. **Configure Parameters**:
   - Select gypsum type (Гипс-Г16, Технический гипс)
   - Choose solution type (with/without microcement)
   - Set colorant percentage (1-5%)
3. **View Results**: See calculated amounts for all ingredients
4. **Save Calculation**: Bookmark calculations for future reference

### **Understanding Results**
The calculator provides precise measurements for:
- **Gypsum Amount**: Base gypsum quantity in grams
- **Microcement**: 18% of gypsum weight (if selected)
- **СВВ**: 1% of gypsum weight for binding
- **Colorant**: User-defined percentage
- **Water**: 55% of gypsum weight for mixing

## 📊 Data Format

### **CSV Structure**
The app reads mold data from `assets/Forms.csv`:

| Column | Description | Example |
|--------|-------------|---------|
| 🔒 Row ID | Unique identifier | `R0VcxD2uRHyEF1e1KZV-wQ` |
| Основное/Название | Mold name | `Ваза бочонок` |
| Основное/фото | Image URL | `https://...` |
| Тип/ID | Category type ID | `A6apoYfmSjCNSjpHvFVmjA` |
| Гипс/Объем, мл | Volume in ml | `250` |
| Выбор/Гипс ID | Predefined gypsum | `sWP8u50jSXi9pkR4aB31tw` |
| Выбор/Смесь ID | Predefined solution | `YO6Ha6xfTzuY8YizbJ4ssA` |
| Выбор/краситель | Predefined colorant | `0,04` |
| Свечи/Свеча | Is candle mold | `true/false` |
| Свечи/Объем, мл | Candle volume | `35` |

### **Category Mapping**
- `A6apoYfmSjCNSjpHvFVmjA` → **Вазы** (Vases)
- `niCjhp9gSS2mGKFf7tytdQ` → **Формы/Свечи** (Forms/Candles)
- `a.e.3JDyUQpi.VKOvfD6otg` → **Скульптуры** (Sculptures)
- `UjcSXWmUSRW40hfMoPAwow` → **Подносы** (Trays)

## 🎨 Design System

### **Colors**
- **Primary**: `#007AFF` (Apple Blue)
- **Secondary**: `#8E8E93` (System Gray)
- **Background**: `#F2F2F7` (System Background)
- **Text**: `#000000` (Black)

### **Typography**
- **Large Title**: 34pt, Bold (-0.5 letter spacing)
- **Title**: 20pt, Semibold
- **Body**: 16pt, Medium
- **Caption**: 14pt, Medium

### **Components**
- **Border Radius**: 16px for cards, 12px for buttons
- **Shadows**: Subtle shadows with 0.08 opacity
- **Animations**: 200ms duration with easeInOut curves

## 📱 Screenshots

```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│  Mold Catalog   │  │ Category Filter │  │  Calculation    │
│                 │  │                 │  │                 │
│  🔍 Search      │  │ [All] [Вазы]    │  │ Ваза бочонок    │
│  [Gypsum][🕯️]  │  │ [Свечи] [Формы] │  │                 │
│                 │  │                 │  │ Гипс: 263г      │
│  ┌─────┐ ┌─────┐ │  │ ┌─────┐ ┌─────┐ │  │ СВВ: 2.6г       │
│  │ 🏺  │ │ 🕯️  │ │  │ │ 🏺  │ │ 🗿  │ │  │ Вода: 145г     │
│  │250ml│ │75ml │ │  │ │250ml│ │75ml │ │  │                 │
│  └─────┘ └─────┘ │  │ └─────┘ └─────┘ │  │ [Save Calc]    │
└─────────────────┘  └─────────────────┘  └─────────────────┘
```

## 🤝 Contributing

### **Development Setup**
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the existing code style and architecture
4. Add tests for new functionality
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### **Code Style**
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names in English
- Add comments for complex business logic
- Maintain the Clean Architecture pattern

### **Testing**
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

## 📈 Performance

- **App Size**: ~15MB (optimized)
- **Startup Time**: <2 seconds on modern devices
- **Memory Usage**: <100MB typical usage
- **Image Loading**: Cached with error fallbacks
- **Smooth Animations**: 60fps on all supported devices

## 🔧 Configuration

### **Adding New Molds**
1. Update `assets/Forms.csv` with new mold data
2. Ensure image URLs are accessible
3. Use proper category type IDs
4. Test the app to verify data loading

### **Customizing Calculations**
Modify calculation logic in:
```dart
lib/data/repositories/calculation_repository_impl.dart
```

Default ratios:
- **Microcement**: 18% of gypsum weight
- **СВВ**: 1% of gypsum weight  
- **Water**: 55% of gypsum weight

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Design Inspiration**: Apple Human Interface Guidelines
- **Icons**: SF Symbols and Material Design
- **Images**: Provided via external URLs in CSV data
- **Community**: Flutter and Dart communities for excellent documentation

---

<div align="center">
  <p><strong>Made with ❤️ for artists and creators</strong></p>
  <p>
    <a href="#gypsart-">⬆️ Back to top</a>
  </p>
</div>
