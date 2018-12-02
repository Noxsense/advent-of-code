module Main where

import Test.HUnit

import qualified Data.Set as Set
import qualified Data.Map as Map
import Data.List

one :: String -> Int
one
  = product
  . traverse (Map.findWithDefault 0) [2,3]
  . Map.unionsWith (+)
  . map (count . occurences)
  . lines

occurences :: String -> Set.Set Int
occurences =
  Set.fromList . Map.elems . count

count :: (Foldable f, Ord a) => f a -> Map.Map a Int
count =
  foldl' (\m k -> Map.insertWith (+) k 1 m) Map.empty

two :: String -> Int
two = const 0

main = do
  runTests "one" one fooTests
  runTests "two" two barTests
  input <- readFile "input.txt"
  print $ one input
  print $ two input

runTests
  :: (Show a, Eq b, Show b)
  => String -> (a -> b) -> [(a, b)] -> IO Counts
runTests name f ts =
  runTestTT $ TestList $
    zipWith TestLabel (map ((name ++) . show) [1..]) $
      flip map ts $ \(input, expected) ->
        TestCase $
          assertEqual (show input) expected (f input)

fooTests =
  [ ( unlines
        [ "abcdef"
        , "bababc"
        , "abbcde"
        , "abcccd"
        , "aabcdd"
        , "abcdee"
        , "ababab"
        ]
    , 12
    )
  ]

barTests =
  []
