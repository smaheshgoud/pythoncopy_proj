# test_fibonacci.py

import unittest
from fibonacci import calculate_fibonacci

class TestFibonacci(unittest.TestCase):

    def test_calculate_fibonacci(self):
        # Test the first few Fibonacci numbers
        self.assertEqual(calculate_fibonacci(1), 0)
        self.assertEqual(calculate_fibonacci(2), 1)
        self.assertEqual(calculate_fibonacci(3), 1)
        self.assertEqual(calculate_fibonacci(4), 2)
        self.assertEqual(calculate_fibonacci(5), 3)
        self.assertEqual(calculate_fibonacci(6), 5)
        self.assertEqual(calculate_fibonacci(7), 8)

    def test_invalid_input(self):
        # Test for invalid input (n <= 0)
        self.assertEqual(calculate_fibonacci(0), "Invalid input")
        self.assertEqual(calculate_fibonacci(-1), "Invalid input")

if __name__ == '__main__':
    unittest.main()
