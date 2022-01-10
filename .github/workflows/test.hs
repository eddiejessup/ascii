import Data.Maybe
import System.Environment
import System.Process

main =
  do
    ghc <- readGHC <$> getEnv "ghc"
    callProcess "cabal" $ "build" : "all" : constraints ghc
    callProcess "cabal" $ "test" : "all" : "--enable-tests" : constraints ghc

x .= Just y  = Just ("--constraint=" ++ x ++ "==" ++ y)
x .= Nothing = Nothing

data GHC = GHC_8_4 | GHC_8_6 | GHC_8_8 | GHC_8_10 | GHC_9_0 | GHC_9_2

readGHC s = case s of
    "8.4"  -> GHC_8_4
    "8.6"  -> GHC_8_6
    "8.8"  -> GHC_8_8
    "8.10" -> GHC_8_10
    "9.0"  -> GHC_9_0
    "9.2"  -> GHC_9_2

constraints ghc = catMaybes
    [ "base" .= case ghc of
          GHC_8_4  -> Just "4.11.*"
          GHC_8_6  -> Just "4.12.*"
          GHC_8_8  -> Just "4.13.*"
          GHC_8_10 -> Just "4.14.*"
          GHC_9_0  -> Just "4.15.*"
          GHC_9_2  -> Just "4.16.*"
    , "bytestring" .= case ghc of
          GHC_8_4  -> Just "0.10.*"
          GHC_8_8  -> Just "0.11.*"
          _        -> Nothing
    , "hashable" .= case ghc of
          GHC_8_4  -> Just "1.2.*"
          GHC_8_6  -> Just "1.2.*"
          GHC_9_0  -> Just "1.4.*"
          _        -> Nothing
    , "template-haskell" .= case ghc of
          GHC_8_4  -> Just "2.13.*"
          GHC_8_6  -> Just "2.14.*"
          GHC_8_8  -> Just "2.15.*"
          GHC_8_10 -> Just "2.16.*"
          GHC_9_0  -> Just "2.17.*"
          GHC_9_2  -> Just "2.18.*"
    , "text" .= case ghc of
          GHC_8_4  -> Just "1.2.3.0"
          GHC_8_10 -> Just "1.2.4.*"
          GHC_9_0  -> Just "1.2.5.*"
          _        -> Nothing
    ]

