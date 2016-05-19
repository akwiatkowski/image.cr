require "./spec_helper"

describe Image do

  it "initializes to zero" do
    img = Image::Tga.new(10, 20)
    img.width.should eq(10)
    img.height.should eq(20)

    img[10].blue.should eq(0)
    img[20].red.should eq(0)
  end

  it "sets color values" do
    img = Image::Tga.new(10, 20)
    img[10].blue = 10u8
    img[20].red = 5u8

    img[10].blue.should eq(10)
    img[20].red.should eq(5)
  end

  it "writes and reads" do
    filename = "test.tga"

    img = Image::Tga.new(10, 20)
    img[10].blue = 10u8
    img[20].red = 5u8

    img.write(filename)
    img2 = Image::Tga.read(filename)

    # This asserts that img2 is not nil
    img2.should_not be_nil

    # Still necessary to satisfy the type checker
    if img2
      img.width.should eq(img2.width)
      img.height.should eq(img2.height)
      img.img_data.should eq(img2.img_data)
    end
  end

  it "creates 2x2 pixel image" do
    filename = "test2.tga"

    img = Image::Tga.new(2, 2)
    img[0,0].blue = 255u8
    img[0,0].red = 0u8
    img[0,0].green = 0u8

    img[1,0].blue = 0u8
    img[1,0].red = 255u8
    img[1,0].green = 0u8

    img[0,1].blue = 0u8
    img[0,1].red = 0u8
    img[0,1].green = 255u8

    img[1,1].blue = 255u8
    img[1,1].red = 255u8
    img[1,1].green = 0u8

    img.write(filename)
  end
end
