#The draw command will draw once and wait for input
#The user will add vectors etc to be drawn

attr_accessor :back_color, :width, :height, :vertices, :d_font, :output, :mouseDX, :mouseDY, :selected_vertex

def setup
    @width = 800
    @height = 600

    @selected_vertex = 0;

    @vertices = Array.new

    @d_font = create_font('Helvetica', 10)
    text_font @d_font

    content = ARGV[0]
    content.gsub! "[", ""
    content.gsub! "]", ""
    content.gsub! " ", ""
    content = content.split(",").map { |s| s.to_f}

    content.each do |c|
        @vertices.push(c.to_f)
    end

    @vertices = @vertices.each_slice(3).to_a

    size @width, @height
    frame.set_title 'Vertex Planner'

    @back_color = [0, 0, 0]

    color_mode RGB, 1
    smooth
end

def draw
    @mouseDX = (mouseX.to_f - @width / 2) / (@width / 2)
    @mouseDY = (mouseY.to_f - @height / 2) / (@height / 2)
    key_handling
    draw_background
    draw_vertices
    fill(1, 1, 1)
    text @mouseDX.to_s, 700, 600 - 30
    text @mouseDY.to_s, 700, 600 - 15
    if @selected_vertex == nil
        @selected_vertex = 0
    end
    text (@selected_vertex).to_s, 0, 600 - 15
end

def mousePressed
    handle_mouse
end

def mouseDragged
    handle_mouse
end

def keyReleased
    if key == '-'
        @selected_vertex -= 1
    elsif key == '='
        @selected_vertex += 1
    elsif key == 'r'
        if @selected_vertex != nil
            @vertices.delete_at @selected_vertex
        end
    elsif key == 's'
        write_vertices
    elsif key == 'q'
        write_vertices
        exit
    end
end

def write_vertices
    @output = createWriter("_displayer.v")
    counter = 0
    @vertices.each do |p|
        if counter != 0
            @output.print(", ")
        end
        @output.print(p[0].to_s + ", " + p[1].to_s + ", " + p[2].to_s)
        counter += 1
    end
    @output.flush()
    @output.close()
end

def handle_mouse
    if @selected_vertex != nil
        if @vertices[@selected_vertex] == nil
            @vertices.push([@mouseDX, @mouseDY, 0])
            return
        end
        @vertices[@selected_vertex][0] = @mouseDX
        @vertices[@selected_vertex][1] = @mouseDY
    end
end

def key_handling
    if ('0'..'9') === key
        @selected_vertex = key.to_i
    end
end

def draw_vertices
    no_stroke
    fill(1, 1, 1)
    
    counter = 0
    @vertices.each do |point|
        x = point[0] * @width / 2 + @width / 2
        y = point[1] * @height / 2 + @height / 2

        fill(1, 1, 1)
        rect(x, y, 12, 12)

        fill(0, 0, 0)
        text counter.to_s, x, y + 10

        counter += 1
    end
end

def draw_background
    background(@back_color[0], @back_color[1], @back_color[2])
    stroke 255, 255, 255
    line 0, @height / 2, @width, @height / 2
    line @width / 2, 0, @width / 2, @height
end
