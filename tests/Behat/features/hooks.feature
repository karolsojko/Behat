Feature: hooks
  In order to hook into Behat testing process
  As a tester
  I need to be able to write hooks

  Background:
    Given a standard Behat project directory structure
    And a file named "features/support/env.php" with:
      """
      <?php
      require_once 'PHPUnit/Autoload.php';
      require_once 'PHPUnit/Framework/Assert/Functions.php';
      """
    And a file named "features/steps/steps.php" with:
      """
      <?php
      $steps->Given('/^I have entered (\d+)$/', function($world, $arg1) {
          $world->number = $arg1;
      });
      $steps->Then('/^I must have (\d+)$/', function($world, $arg1) {
          assertEquals($world->number, $arg1);
      });
      """
    And a file named "features/support/hooks.php" with:
      """
      <?php
      $hooks->before('features.load', function($event) {
          echo 'BEFORE features.load: ' . get_class($event->getSubject()) . "\n";
      });
      $hooks->after('features.load', function($event) {
          echo 'AFTER features.load: ' . get_class($event->getSubject()) . "\n";
      });
      $hooks->before('features.test', function($event) {
          echo 'BEFORE features.test: ' . get_class($event->getSubject()) . "\n";
      });
      $hooks->after('features.test', function($event) {
          echo 'AFTER features.test: ' . get_class($event->getSubject()) . "\n";
      });
      """

  Scenario:
    Given a file named "features/test.feature" with:
      """
      Feature:
        Scenario:
          Given I have entered 12
          Then I must have 12
      """
    When I run "behat -f progress"
    Then it should pass with:
      """
      BEFORE features.load: Everzet\Behat\Loader\FeaturesLoader
      AFTER features.load: Everzet\Behat\Loader\FeaturesLoader
      BEFORE features.test: Everzet\Behat\Runner\FeaturesRunner
      ..AFTER features.test: Everzet\Behat\Runner\FeaturesRunner
      
      
      1 scenarios (1 passed)
      2 steps (2 passed)
      """
