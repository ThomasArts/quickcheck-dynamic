{-# LANGUAGE UndecidableInstances #-}

module Test.QuickCheck.StateModel.IOSim where

import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad.Class.MonadFork qualified as IOClass
import Control.Monad.Class.MonadSTM qualified as IOClass
import Control.Monad.IOSim

-- TODO: when we've updated the dependency on io-sim
-- import Control.Monad.Class.MonadMVar qualified as IOClass

import Test.QuickCheck.StateModel

type family RealizeIOSim s a where
  RealizeIOSim s ThreadId = IOClass.ThreadId (IOSim s)
  RealizeIOSim s (TVar a) = IOClass.TVar (IOSim s) a
-- TODO: when we've updated the dependency on io-sim
-- RealizeIOSim s (MVar a) = IOClass.MVar (IOSim s) a
-- TODO: unfortunately no poly-kinded recursion for type families
-- so we can't do something like :'(
-- RealizeIOSim s (f a)    = (RealizeIOSim f) (RealizeIOSim s a)
  RealizeIOSim s (f a b) = f (RealizeIOSim s a) (RealizeIOSim s b)
  RealizeIOSim s (f a) = f (RealizeIOSim s a)
  RealizeIOSim s a = a

type instance Realized (IOSim s) a = RealizeIOSim s a
