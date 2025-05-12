# ai_plus_project to-Do App
Простое Flutter-приложение для списка задач с фильтрацией и сохранением

## Стек
- Flutter  
- provider  
- shared_preferences  

## Управление состоянием
- provider + ChangeNotifier 
- `TaskProvider` хранит список и методы (`addTask`, `toggleTask`, `removeTask`, `setFilter`)  
- При изменениях — `notifyListeners()`, UI подписывается через `context.watch`  

## Библиотеки
- provider: ^6.1.5 
- shared_preferences: ^2.5.3
- dart:convert
- flutter/material  
