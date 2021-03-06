require 'chunky_png'

world = World.find ARGV[0]
canvas = ChunkyPNG::Image.new world.width, world.height, ChunkyPNG::Color(139,69,19)

ResourceTile.where(:world_id => world.id).find_in_batches do |group|
  group.each do |rt|
    x = rt.x
    y = rt.y
    case rt.type
      when WaterTile.to_s
        canvas[x,y] = ChunkyPNG::Color :blue
      when LandTile.to_s
        if rt.tree_density > 0.01
          color = ChunkyPNG::Color.rgba(0, 160, 0, (rt.tree_density * 255).to_i)
          canvas[x,y] = color
        end
    end
  end
end

canvas.save ARGV[1]

