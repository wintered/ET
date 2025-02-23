import Data.List
import System.IO
import System.Environment
import Data.List (find)
import Data.Maybe (catMaybes)
import System.Posix.Files (getFileStatus, fileSize)
import System.Directory (doesFileExist)
import Test.Feat.Enumerate
import Control.Enumerable
import Test.Feat.Access
import Test.Feat

data Paropen = C0_paropen 
instance Show Paropen where
  show C0_paropen  = "("
instance Enumerable Paropen where
  enumerate = share $ aconcat [c0 C0_paropen]

data Parclose = C0_parclose 
instance Show Parclose where
  show C0_parclose  = ")"
instance Enumerable Parclose where
  enumerate = share $ aconcat [c0 C0_parclose]

data Var_name_a0 = C0_var_name_a0 
instance Show Var_name_a0 where
  show C0_var_name_a0  = "a0"
instance Enumerable Var_name_a0 where
  enumerate = share $ aconcat [c0 C0_var_name_a0]

data Var_name_a1 = C0_var_name_a1 
instance Show Var_name_a1 where
  show C0_var_name_a1  = "a1"
instance Enumerable Var_name_a1 where
  enumerate = share $ aconcat [c0 C0_var_name_a1]

data Var_name_a2 = C0_var_name_a2 
instance Show Var_name_a2 where
  show C0_var_name_a2  = "a2"
instance Enumerable Var_name_a2 where
  enumerate = share $ aconcat [c0 C0_var_name_a2]

data Var_name_a3 = C0_var_name_a3 
instance Show Var_name_a3 where
  show C0_var_name_a3  = "a3"
instance Enumerable Var_name_a3 where
  enumerate = share $ aconcat [c0 C0_var_name_a3]

data Var_name_a4 = C0_var_name_a4 
instance Show Var_name_a4 where
  show C0_var_name_a4  = "a4"
instance Enumerable Var_name_a4 where
  enumerate = share $ aconcat [c0 C0_var_name_a4]

data Cmd_declare_const = C0_cmd_declare_const 
instance Show Cmd_declare_const where
  show C0_cmd_declare_const  = "declare-const"
instance Enumerable Cmd_declare_const where
  enumerate = share $ aconcat [c0 C0_cmd_declare_const]

data Declareconsta0 = C0_declareconsta0 Paropen Cmd_declare_const Var_name_a0 Var_type Parclose
instance Show Declareconsta0 where
  show (C0_declareconsta0 a0 a1 a2 a3 a4) = show a0 ++ " " ++ show a1 ++ " " ++ show a2 ++ " " ++ show a3 ++ " " ++ show a4
instance Enumerable Declareconsta0 where
  enumerate = share $ aconcat [pay(c5 C0_declareconsta0)]

data Declareconsta1 = C0_declareconsta1 Paropen Cmd_declare_const Var_name_a1 Var_type Parclose
instance Show Declareconsta1 where
  show (C0_declareconsta1 a0 a1 a2 a3 a4) = show a0 ++ " " ++ show a1 ++ " " ++ show a2 ++ " " ++ show a3 ++ " " ++ show a4
instance Enumerable Declareconsta1 where
  enumerate = share $ aconcat [pay(c5 C0_declareconsta1)]

data Declareconsta2 = C0_declareconsta2 Paropen Cmd_declare_const Var_name_a2 Var_type Parclose
instance Show Declareconsta2 where
  show (C0_declareconsta2 a0 a1 a2 a3 a4) = show a0 ++ " " ++ show a1 ++ " " ++ show a2 ++ " " ++ show a3 ++ " " ++ show a4
instance Enumerable Declareconsta2 where
  enumerate = share $ aconcat [pay(c5 C0_declareconsta2)]

data Declareconsta3 = C0_declareconsta3 Paropen Cmd_declare_const Var_name_a3 Var_type Parclose
instance Show Declareconsta3 where
  show (C0_declareconsta3 a0 a1 a2 a3 a4) = show a0 ++ " " ++ show a1 ++ " " ++ show a2 ++ " " ++ show a3 ++ " " ++ show a4
instance Enumerable Declareconsta3 where
  enumerate = share $ aconcat [pay(c5 C0_declareconsta3)]

data Declareconsta4 = C0_declareconsta4 Paropen Cmd_declare_const Var_name_a4 Var_type Parclose
instance Show Declareconsta4 where
  show (C0_declareconsta4 a0 a1 a2 a3 a4) = show a0 ++ " " ++ show a1 ++ " " ++ show a2 ++ " " ++ show a3 ++ " " ++ show a4
instance Enumerable Declareconsta4 where
  enumerate = share $ aconcat [pay(c5 C0_declareconsta4)]

data Var_type = C0_var_type 
instance Show Var_type where
  show C0_var_type  = "Bool"
instance Enumerable Var_type where
  enumerate = share $ aconcat [c0 C0_var_type]

data B_const = C0_b_const | C1_b_const 
instance Show B_const where
  show C0_b_const  = "true"
  show C1_b_const  = "false"
instance Enumerable B_const where
  enumerate = share $ aconcat [c0 C0_b_const,c0 C1_b_const]

data Op_not = C0_op_not 
instance Show Op_not where
  show C0_op_not  = "not"
instance Enumerable Op_not where
  enumerate = share $ aconcat [c0 C0_op_not]

data Op_and = C0_op_and 
instance Show Op_and where
  show C0_op_and  = "and"
instance Enumerable Op_and where
  enumerate = share $ aconcat [c0 C0_op_and]

data Op_or = C0_op_or 
instance Show Op_or where
  show C0_op_or  = "or"
instance Enumerable Op_or where
  enumerate = share $ aconcat [c0 C0_op_or]

data Op_xor = C0_op_xor 
instance Show Op_xor where
  show C0_op_xor  = "xor"
instance Enumerable Op_xor where
  enumerate = share $ aconcat [c0 C0_op_xor]

data Op_equals = C0_op_equals 
instance Show Op_equals where
  show C0_op_equals  = "="
instance Enumerable Op_equals where
  enumerate = share $ aconcat [c0 C0_op_equals]

data Op_distinct = C0_op_distinct 
instance Show Op_distinct where
  show C0_op_distinct  = "distinct"
instance Enumerable Op_distinct where
  enumerate = share $ aconcat [c0 C0_op_distinct]

data Op_ite = C0_op_ite 
instance Show Op_ite where
  show C0_op_ite  = "ite"
instance Enumerable Op_ite where
  enumerate = share $ aconcat [c0 C0_op_ite]

data Bool_term = C0_bool_term B_const| C1_bool_term Var_name_a0| C2_bool_term Var_name_a1| C3_bool_term Var_name_a2| C4_bool_term Var_name_a3| C5_bool_term Var_name_a4| C6_bool_term Paropen Op_not Bool_term Parclose| C7_bool_term Paropen Op_and Bool_term Bool_term Parclose| C8_bool_term Paropen Op_or Bool_term Bool_term Parclose| C9_bool_term Paropen Op_xor Bool_term Bool_term Parclose| C10_bool_term Paropen Op_equals Bool_term Bool_term Parclose| C11_bool_term Paropen Op_distinct Bool_term Bool_term Parclose| C12_bool_term Paropen Op_ite Bool_term Bool_term Bool_term Parclose
instance Show Bool_term where
  show (C0_bool_term a0) = show a0
  show (C1_bool_term a0) = show a0
  show (C2_bool_term a0) = show a0
  show (C3_bool_term a0) = show a0
  show (C4_bool_term a0) = show a0
  show (C5_bool_term a0) = show a0
  show (C6_bool_term a0 a1 a2 a3) = show a0 ++ " " ++ show a1 ++ " " ++ show a2 ++ " " ++ show a3
  show (C7_bool_term a0 a1 a2 a3 a4) = show a0 ++ " " ++ show a1 ++ " " ++ show a2 ++ " " ++ show a3 ++ " " ++ show a4
  show (C8_bool_term a0 a1 a2 a3 a4) = show a0 ++ " " ++ show a1 ++ " " ++ show a2 ++ " " ++ show a3 ++ " " ++ show a4
  show (C9_bool_term a0 a1 a2 a3 a4) = show a0 ++ " " ++ show a1 ++ " " ++ show a2 ++ " " ++ show a3 ++ " " ++ show a4
  show (C10_bool_term a0 a1 a2 a3 a4) = show a0 ++ " " ++ show a1 ++ " " ++ show a2 ++ " " ++ show a3 ++ " " ++ show a4
  show (C11_bool_term a0 a1 a2 a3 a4) = show a0 ++ " " ++ show a1 ++ " " ++ show a2 ++ " " ++ show a3 ++ " " ++ show a4
  show (C12_bool_term a0 a1 a2 a3 a4 a5) = show a0 ++ " " ++ show a1 ++ " " ++ show a2 ++ " " ++ show a3 ++ " " ++ show a4 ++ " " ++ show a5
instance Enumerable Bool_term where
  enumerate = share $ aconcat [c1 C0_bool_term,c1 C1_bool_term,c1 C2_bool_term,c1 C3_bool_term,c1 C4_bool_term,c1 C5_bool_term,pay(c4 C6_bool_term),pay(c5 C7_bool_term),pay(c5 C8_bool_term),pay(c5 C9_bool_term),pay(c5 C10_bool_term),pay(c5 C11_bool_term),pay(c6 C12_bool_term)]

data Cmd_checksat = C0_cmd_checksat 
instance Show Cmd_checksat where
  show C0_cmd_checksat  = "check-sat"
instance Enumerable Cmd_checksat where
  enumerate = share $ aconcat [c0 C0_cmd_checksat]

data Checksat = C0_checksat Paropen Cmd_checksat Parclose
instance Show Checksat where
  show (C0_checksat a0 a1 a2) = show a0 ++ " " ++ show a1 ++ " " ++ show a2
instance Enumerable Checksat where
  enumerate = share $ aconcat [pay(c3 C0_checksat)]

data Cmd_assert = C0_cmd_assert 
instance Show Cmd_assert where
  show C0_cmd_assert  = "assert"
instance Enumerable Cmd_assert where
  enumerate = share $ aconcat [c0 C0_cmd_assert]

data Assertstatement = C0_assertstatement Paropen Cmd_assert Bool_term Parclose
instance Show Assertstatement where
  show (C0_assertstatement a0 a1 a2 a3) = show a0 ++ " " ++ show a1 ++ " " ++ show a2 ++ " " ++ show a3
instance Enumerable Assertstatement where
  enumerate = share $ aconcat [pay(c4 C0_assertstatement)]

data Start = C0_start Declareconsta0 Declareconsta1 Declareconsta2 Declareconsta3 Declareconsta4 Assertstatement Checksat
instance Show Start where
  show (C0_start a0 a1 a2 a3 a4 a5 a6) = show a0 ++ " " ++ show a1 ++ " " ++ show a2 ++ " " ++ show a3 ++ " " ++ show a4 ++ " " ++ show a5 ++ " " ++ show a6
instance Enumerable Start where
  enumerate = share $ aconcat [c7 C0_start]

getFileSize :: FilePath -> IO (Maybe Integer)
getFileSize filePath = do
  fileExists <- doesFileExist filePath
  if fileExists
    then do
      status <- getFileStatus filePath
      let size = fromIntegral (System.Posix.Files.fileSize status)
      return (Just size)
    else
      return Nothing

formulaByLogIdx :: Integer -> IO (Maybe Integer)
formulaByLogIdx i = do    
 let filePath = "formula.smt2"
 let formula = show (index (10^i) :: Start)
 writeFile filePath formula
 fileSize <- getFileSize filePath
 return fileSize

main :: IO ()
main = do
  putStrLn "Coarse log idx search (> 8192 bytes)..."  
  sizes <- sequence [formulaByLogIdx i | i <- [1..2000]]
  let log_idx = findIndex (> 8192) (catMaybes sizes)
  case log_idx of
    Just index -> print index 
    Nothing -> putStrLn "Coarse log idx search unsucessful."
