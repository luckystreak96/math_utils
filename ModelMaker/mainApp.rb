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
    when "VADD"
        if command[1] == nil or command[2] == nil or command[3] == nil
            puts "Arguments missing!"
            next
        end
        @vertices.push command[1]
        @vertices.push command[2]
        @vertices.push command[3]
    when "VMOD"
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
    when "NAME"
        if command[1] != nil
            @models.name = command[1]
        end
    when "HELP"
        if command[1] == "--example"
            #Full usage example
            puts "Step 1: getModel {model_name}"
            puts "Line that starts with 'model_name' from 'models.data' is loaded -- vertices and indices"
            puts "Step 2: run"
            puts "Runs the displayer program"
            puts "Step 3: pull  (pullv for vertices, pulli for indices)"
            puts "After saving verts and ind from the program, import them here"
            puts "Step 4: save"
            puts "Overwrite the old model with the new stuff"
            puts "Step 5: exit"
            puts "Done :)"
        elsif command[1] == "--model"
            puts "A model had 3 parts: Name, Vertices, Indices"
            puts
            puts "Models:"
            puts "  getModel {Model_Name}"
            puts "  newModel {Model_Name}"
            puts "  run (opens Displayer)"
            puts
            puts "Name:"
            puts "  name {new_name}"
            puts
            puts "Vertices:"
            puts "  printv (print vertices)"
            puts "  pullv (overwrites vertices with the ones from the Displayer)"
            puts "  vmod {Vertex_Number} {0..2 => x..z} ['+', '-'] {Value}"
            puts "      example: vmod 0 0 + 0.1"
            puts "      (modifies one point of a vertex)"
            puts "  vadd {X_Value} {Y_Value} {Z_Value}"
            puts "      (adds a vertex)"
            puts
            puts "Indices:"
            puts "  printi (print indices)"
            puts "  pulli (overwrites indices with the ones from the Displayer)"
            puts "  imod {Index_Number} {0..2} {Value}"
            puts "      example: imod 3 1 5"
            puts "      (modifies one point of an index)"
            puts "  iadd {X_Value} {Y_Value} {Z_Value}"
            puts "      (adds an index)"
        elsif command[1] == "--displayer"
            puts "Displayer: Window for drawing current model"
            puts
            puts "Vertex Selection:"
            puts "  Select a vertex to move:"
            puts "  '0', '1', '2'..."
            puts "  '=' and '-' => add or subtract the selected vertex by 1"
            puts
            puts "Once the desired vertex is selected:"
            puts "  Click and drag to place"
            puts "  Press 'r' to remove it"
            puts
            puts "Press 's' to save progress"
            puts "Press 'q' to save and exit"
            puts "Press the 'x' in the corner to quit without saving"
        else
            puts "Try the following: "
            puts "help --example"
            puts "help --model"
            puts "help --displayer"
        end
    else
        puts "Command doesn't exist, consider checking your spelling?"
    end
end

