/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-12-18T02:44:19.712Z

part of gazer_set;

// **************************************************************************
// Generator: ZengenGenerator
// Target: library gazer_set
// **************************************************************************

@GeneratedFrom(_GazerSet)
class GazerSet extends Object with Events implements Set<dynamic> {
  Set _gazers = new Set();

  Logger _logger;

  GazerSet(Logger this._logger);

  Stream<int> get onLengthChanged => on("lengthChanged");

  void sendMessage(String message) {
    _logger.fine("Sending message to all gazers: $message");
    _gazers.forEach((ws) => ws.add(message));
  }

  @override
  bool add(value) {
    if (_gazers.add(value)) {
      emit("lengthChanged", _gazers.length);
      return true;
    } else {
      return false;
    }
  }

  @override
  bool remove(value) {
    if (_gazers.remove(value)) {
      emit("lengthChanged", _gazers.length);
      return true;
    } else {
      return false;
    }
  }

  dynamic elementAt(int index) => _gazers.elementAt(index);
  dynamic singleWhere(bool test(dynamic element)) => _gazers.singleWhere(test);
  dynamic lastWhere(bool test(dynamic element), {dynamic orElse()}) =>
      _gazers.lastWhere(test, orElse: orElse);
  dynamic firstWhere(bool test(dynamic element), {dynamic orElse()}) =>
      _gazers.firstWhere(test, orElse: orElse);
  Iterable skipWhile(bool test(dynamic value)) => _gazers.skipWhile(test);
  Iterable skip(int count) => _gazers.skip(count);
  Iterable takeWhile(bool test(dynamic value)) => _gazers.takeWhile(test);
  Iterable take(int count) => _gazers.take(count);
  List toList({bool growable: true}) => _gazers.toList(growable: growable);
  bool any(bool f(dynamic element)) => _gazers.any(f);
  String join([String separator = ""]) => _gazers.join(separator);
  bool every(bool f(dynamic element)) => _gazers.every(f);
  dynamic fold(dynamic initialValue,
          dynamic combine(dynamic previousValue, dynamic element)) =>
      _gazers.fold(initialValue, combine);
  dynamic reduce(dynamic combine(dynamic value, dynamic element)) =>
      _gazers.reduce(combine);
  void forEach(void f(dynamic element)) {
    _gazers.forEach(f);
  }

  Iterable expand(Iterable f(dynamic element)) => _gazers.expand(f);
  Iterable where(bool f(dynamic element)) => _gazers.where(f);
  Iterable map(dynamic f(dynamic element)) => _gazers.map(f);
  dynamic get single => _gazers.single;
  dynamic get last => _gazers.last;
  dynamic get first => _gazers.first;
  bool get isNotEmpty => _gazers.isNotEmpty;
  bool get isEmpty => _gazers.isEmpty;
  int get length => _gazers.length;
  Set toSet() => _gazers.toSet();
  void clear() {
    _gazers.clear();
  }

  Set difference(Set<dynamic> other) => _gazers.difference(other);
  Set union(Set<dynamic> other) => _gazers.union(other);
  Set intersection(Set<Object> other) => _gazers.intersection(other);
  bool containsAll(Iterable<Object> other) => _gazers.containsAll(other);
  void retainWhere(bool test(dynamic element)) {
    _gazers.retainWhere(test);
  }

  void removeWhere(bool test(dynamic element)) {
    _gazers.removeWhere(test);
  }

  void retainAll(Iterable<Object> elements) {
    _gazers.retainAll(elements);
  }

  void removeAll(Iterable<Object> elements) {
    _gazers.removeAll(elements);
  }

  dynamic lookup(Object object) => _gazers.lookup(object);
  void addAll(Iterable<dynamic> elements) {
    _gazers.addAll(elements);
  }

  bool contains(Object value) => _gazers.contains(value);
  Iterator get iterator => _gazers.iterator;
}
