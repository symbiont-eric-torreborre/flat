{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
-- |Encoding and decoding functions
module Data.Flat.Run (
    flat,
    flatRaw,
    unflat,
    unflatWith,
    unflatRaw,
    unflatRawWith,
    ) where

import qualified Data.ByteString         as B
import           Data.ByteString.Convert
import           Data.Flat.Class
import           Data.Flat.Decoder
import qualified Data.Flat.Encoder       as E
import           Data.Flat.Filler

-- |Encode padded value.
flat :: Flat a => a -> B.ByteString
flat = flatRaw . postAligned

-- |Decode padded value.
unflat :: (Flat a,AsByteString b) => b -> Decoded a
unflat = unflatWith decode

-- |Decode padded value, using the provided unpadded decoder.
unflatWith :: AsByteString b => Get a -> b -> Decoded a
unflatWith dec = unflatRawWith (postAlignedDecoder dec)

-- |Decode unpadded value.
unflatRaw :: (Flat a,AsByteString b) => b -> Decoded a
unflatRaw = unflatRawWith decode

-- |Unflat unpadded value, using provided decoder
unflatRawWith :: AsByteString b => Get a -> b -> Decoded a
unflatRawWith dec = strictDecoder dec . toByteString

-- |Encode unpadded value
flatRaw :: (Flat a, AsByteString b) => a -> b
flatRaw a = fromByteString $ E.strictEncoder (getSize a) (encode a)
