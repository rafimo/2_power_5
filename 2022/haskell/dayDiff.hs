-- cerner_2tothe5th_2022
-- number of days between dates
-- including the end-date though it will be 33!
import Data.Time
main = do
  let a = fromGregorian 2022 09 15
  let b = fromGregorian 2022 10 17
  print (diffDays b a)
