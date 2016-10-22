@matrices = [
    [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
    ],
    [
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1]
    ],
    [
        [1, 0, 0, 0.5],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1]
    ],
]

#def set(loc, value)
#    row = loc / value
#    col = loc % value
#    @matrix[row][col] = value
#end

def printmatrices
    count = 0;
    @matrices.each do |matrix|
        puts "Matrix " + count.to_s
        count += 1
        for i in 0..3
            for o in 0..3
                print matrix[i][o]
                print " "
            end
            print "\n"
        end
        print "\n"
    end
end

def multiply(mat1, mat2, target)
    for row in 0..3
        for column in 0..3
            result = 0

            for value in 0..3
                result += @matrices[mat1][row][value] * @matrices[mat2][value][column]
            end

            @matrices[target][row][column] = result

        end
    end
end

printmatrices
puts "M = Multiply | Q = Quit"
while (input = gets.chomp) != "q"

    if input == "m"
        puts "Mat1: "
        mat1 = gets.chomp.to_i
        puts "Mat2: "
        mat2 = gets.chomp.to_i
        puts "Result Matrix: "
        matRes = gets.chomp.to_i
        multiply(mat1, mat2, matRes)
    end
=begin
    if input == "s"
        print "Location: "
        loc = gets.chomp.to_i
        print "Value: "
        value = gets.chomp.to_i
        set(loc, value)
    end
=end

    printmatrices
    puts "M = Multiply | Q = Quit"
end
