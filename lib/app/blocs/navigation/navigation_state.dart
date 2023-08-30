part of 'navigation_cubit.dart';

abstract class NavigationState {}

class NavigationInitial extends NavigationState {}

class NavigationNextRoute extends NavigationState {
  final String nextRoute;

  NavigationNextRoute(this.nextRoute);
}
