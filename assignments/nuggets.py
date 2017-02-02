def is_nugget_number(candidate, a = 6, b = 9, c = 20):
    for i in range(candidate//a + 1):
        for j in range(candidate//b + 1):
            for k in range(candidate//c + 1):
                if(a*i + b*j + c*k == candidate):
                    return True

    return False


def main():
    candidate = 6
    biggest = 0
    counter = 0
    smallest_package = 6 

    while(counter < smallest_package):
        result = is_nugget_number(candidate)

        if(result):
            counter += 1
        else:
            biggest = candidate
            counter = 0

        candidate += 1

    print("The largest number that you cannot buy is: {}".format(biggest))

            
if __name__ == "__main__":
    main()
