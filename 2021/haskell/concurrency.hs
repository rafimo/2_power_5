-- concurrency in haskell
-- cerner_2tothe5th_2021
import Control.Concurrent (forkIO, threadDelay)
import Data.Foldable (for_)

main = do
    let a = [1, 3, 5]

    forkIO (print_ a "group1")
    let a = [2, 4, 6]
    forkIO (print_ a "group2")
    
    -- Wait for threads to finish.
    threadDelay 13000

-- print messages    
print_ a name = for_ a printMessage
    where printMessage i = do
            threadDelay (i * 1000)
            putStrLn (name ++ " number " ++ show i)
