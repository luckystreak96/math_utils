#Main program to modify everything and run the other assets
#

class Models
    attr_accessor :file_lines, :filename, :last_access_line, :last_name

    def initialize filename
        @filename = filename
        get_all_models @filename
        puts @file_lines
        backup
    end

    def find_model model_name
        counter = 0
        @file_lines.each do |line|
            if line.split("|")[0] == model_name
                @last_access_line = counter
                @last_name = model_name
                return line
            end
            counter += 1
        end
    end

    def save verts, ind
        mod_line = @last_name + "|"
        counter = 0
        verts.each do |v|
            if counter != 0
                mod_line += ", "
            end
            mod_line += v.to_s
            counter += 1
        end

        if ind != nil
            counter = 0
            mod_line += "|"
            ind.each do |i|
                if counter != 0
                    mod_line += ", "
                end
                mod_line += i.to_s
            end
        end

        @file_lines[@last_access_line] = mod_line
        begin
            #File.open(@filename, "w") {}
            file = File.open(@filename, "w")
            @file_lines.each do |line|
                file.write(line + "\n")
            end
        rescue IOError => e
            #shit
            print "Error writing to file"
        ensure
            file.close unless file.nil?
        end

        puts @file_lines
    end

    def backup
        begin
            file = File.open(@filename + "_backup", "w+")
            @file_lines.each do |line|
                file.write(line + "\n")
            end
        rescue IOError => e
            print "Error writing backup"
        ensure
            file.close unless file.nil?
        end
    end

    def get_all_models filename
        @file_lines = Array.new
        File.foreach(filename) do |line|
            @file_lines.push line
        end
        @file_lines.each do |line|
            line.gsub! " ", ""
            line.gsub! "\t", ""
            line.gsub! "\n", ""
            line.gsub! "\r", ""
        end
    end
end

@models = Models.new "models.data"

@vertices = Array.new

def print_vertices
    puts
    puts "Vertices: "

    counter = 0
    points = @vertices.each_slice(3).to_a
    points.each do |p|
        puts counter.to_s + ": " + p*", "
        counter += 1
    end
end

def get_vertices model_name
    #Re-initialize the array
    @vertices = Array.new

    line = @models.find_model model_name
    split_line = line.split("|")
    split_numbers = split_line[1].split(",")
    split_numbers.each do |num|
        @vertices.push(num.to_f)
    end
    print_vertices
end

def input filename
    line_num = 0
    lines = File.open(filename).read
    lines.each_line do |line|
        print "#{line_num += 1}: #{line}"
    end
end

#============== MAIN LOOP =================

while (command = gets.chomp.split(" "))[0].upcase != 'EXIT'
    case command[0].upcase
    when "HELP"
        puts "Commands: "
        puts "Run the vertex displayer: \nrun\n"
        puts "Read contents of a file: \nread {filename}\n"
        puts "Retrieve vertices from file: \ngetVert [filename]\n"
        puts "Modify existing vertex: \nm {Vertex Number} {0 => x, 1 => y, 2 => z} ['+', '-'] {New Value}\n"
        puts "Add new vertex: \na {x} {y} {z}\n"
        puts "Exit program: \nexit"
    when "GETVERT"
        if command[1] == nil
            command[1] = "bunny"
        end
        get_vertices(command[1])
    when "READ"
        if command[1] == nil or command[2] == nil
            puts "Arguments missing!"
            next
        end
        input command[1]
    when "PRINT"
        print_vertices
    when "TEST"
        get_vertices("bunny")
         system("rp5 run vertexPlanner.rb #{@vertices*","}")
         puts $?.exitstatus
    when "RUN"
         system("rp5 run vertexPlanner.rb #{@vertices*","}")
         puts $?.exitstatus
    when "SAVE"
        @models.save @vertices, nil
    when "A"
        if command[1] == nil or command[2] == nil or command[3] == nil
            puts "Arguments missing!"
            next
        end
        @vertices.push command[1]
        @vertices.push command[2]
        @vertices.push command[3]
    when "M"
        if command[1] == nil or command[2] == nil or command[3] == nil
            puts "Arguments missing!"
            next
        end

        if command[4] == nil
            @vertices[command[1].to_i * 3 + command[2].to_i] = command[3].to_f
        elsif command[3] == "+"
            @vertices[command[1].to_i * 3 + command[2].to_i] += command[4].to_f
        elsif command[3] == "-"
            @vertices[command[1].to_i * 3 + command[2].to_i] -= command[4].to_f
        end
    when "PULLV"
        @vertices = Array.new
        File.foreach("vertices.txt") do |line|
            nums = line.split(",")
            nums.each do |n|
                n.gsub! " ", ""
                n = n.to_f
            end
            nums.each do |n|
                @vertices.push n
            end
        end
    else
        puts "Command doesn't exist, consider checking your spelling?"
    end
end

