require "./image/*"

module Image

  class TgaPixel
    def initialize(@image : Tga, @pixel : Int32)
    end
    def blue
      @image.img_data[3 * @pixel + 0]
    end
    def green
      @image.img_data[3 * @pixel + 1]
    end
    def red
      @image.img_data[3 * @pixel + 2]
    end
    def blue=(value : UInt8)
      @image.img_data[3 * @pixel + 0] = value
    end
    def green=(value : UInt8)
      @image.img_data[3 * @pixel + 1] = value
    end
    def red=(value : UInt8)
      @image.img_data[3 * @pixel + 2] = value
    end
  end # class TgaPixel

  class Tga

    getter width, height, img_data

    def initialize(@width : Int32, @height : Int32)
      @img_data = Slice(UInt8).new(3 * @width * @height)
    end

    protected def img_data=(img_data)
      @img_data = img_data
    end

    def [](px)
      TgaPixel.new(self, px)
    end
    def [](x, y)
      TgaPixel.new(self, x + y * @width)
    end

    def self.read(filename)
      File.open(filename) do |file|
        # TODO: Ensure that Header and Delimiter are legal

        # Header
        12.times{ file.read_byte }

        # Width information
        w_lower = file.read_byte
        w_upper = file.read_byte

        # Height information
        h_lower = file.read_byte
        h_upper = file.read_byte

        2.times{ file.read_byte }

        if w_lower && w_upper && h_lower && h_upper
          width = w_lower + 256 * w_upper
          height = h_lower + 256 * h_lower
          img = new(width.to_i, height.to_i)

          file.read_fully(img.img_data)

          img
        end
      end
    end

    def write(filename)
      File.open(filename, "w") do |file|

        # Header
        12.times{|i| file.write_byte(i == 2 ? 2u8 : 0u8) }

        # Width information
        file.write_byte(UInt8.new(@width % 256))
        file.write_byte(UInt8.new(@width / 256))

        # Height information
        file.write_byte(UInt8.new(@height % 256))
        file.write_byte(UInt8.new(@height / 256))

        # Delimiter
        file.write_byte(24u8)
        file.write_byte(32u8)

        file.write(@img_data)
      end
    end
  end # class PNG
end # module Image
