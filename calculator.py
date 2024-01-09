import math

def print_fixed2signed(num, franctions):
    toPrint = num * pow(2,abs(franctions))
    retVal = round(toPrint)
    print(str(num)+"=>" ,retVal)
    if abs(num) < 1:
        print("bitNum:", abs(franctions))
        pass
    else:
        print("bitNum:", math.ceil(math.log2(retVal)))
        pass
    return retVal
def print_signed2fixed(num, francNum):
    fixed = num / pow(2, francNum)
    print(str(num)+"/pow(2, "+str(francNum)+"):", fixed)
    return fixed
def print_exactOfFranction(exact):
    print("log2("+str(exact)+"):", math.log2(exact))
    rounded = math.floor(math.log2(exact))
    print("round(log2("+str(exact)+")):", -rounded)
    # for exp in range(-1, rounded-1, -1):
    #     print("2^"+str(exp), pow(2, exp))
    #     pass
    return abs(rounded)

print("-------------------------------")
exact = 0.0001
frantionalNum = print_exactOfFranction(exact)
print("-------------------------------")
num = 3.1415
print_fixed2signed(num, frantionalNum)
print("-------------------------------")
print_fixed2signed(3.1415*2/200, 14)
print("-------------------------------")
# res = int(input("enter your unsigend number: "))
# francNum = int(input("enter your franctional num: "))
res = 10300
francNum = 14
print_signed2fixed(res, francNum)
print("-------------------------------")