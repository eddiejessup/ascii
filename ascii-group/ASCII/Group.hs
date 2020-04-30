{- | ASCII characters are broadly categorized into two groups: /control codes/ and /printable characters/.

-}

module ASCII.Group
  (
    -- * The @Group@ type
      Group (..)

    -- * Functions
    , charGroup, inGroup

    -- * Notes
    -- $notes

  ) where

import qualified Prelude
import Prelude ((<), (==), Bool)

import ASCII.Char (Char)
import qualified ASCII.Char as Char

{- $setup

>>> import Prelude
>>> import ASCII.Char

-}

data Group =
    Control -- ^ 33 of the ASCII characters are /control codes/. A few of these are still in use, but most are obsolete relics of the early days of computing.
  | Printable -- ^ 95 of the ASCII characters are /printable characters/ such as letters and numbers, mostly corresponding to the keys on an American English keyboard.

deriving instance Prelude.Eq Group
deriving instance Prelude.Ord Group
deriving instance Prelude.Enum Group
deriving instance Prelude.Bounded Group
deriving instance Prelude.Show Group

{- | Determine which group a particular character belongs to.

>>> map charGroup [CapitalLetterA,EndOfTransmission]
[Printable,Control]

-}

charGroup :: Char -> Group
charGroup x =
    case x of
        _ | (x < Char.Space) -> Control
        Char.Delete          -> Control
        _                    -> Printable

{- | Test whether a character belongs to a particular group.

>>> inGroup Printable EndOfTransmission
False

>>> inGroup Control EndOfTransmission
True

-}

inGroup :: Group -> Char -> Bool
inGroup g x = charGroup x == g

{- $notes

Space is a printable character (perhaps surprisingly, given that it is invisible).

>>> charGroup Space
Printable

Tab is a control code (perhaps surprisingly, given that space is a printable character).

>>> charGroup HorizontalTab
Control

A few examples of printable characters:

>>> all (inGroup Printable) [CapitalLetterA,SmallLetterZ,Digit4,Tilde]
True

A few examples of control characters:

>>> all (inGroup Control) [Null,Substitute,UnitSeparator,Delete]
True

There are 33 control codes.

>>> length (filter (inGroup Control) allCharacters)
33

There are 95 printable characters.

>>> length (filter (inGroup Printable) allCharacters)
95

-}
