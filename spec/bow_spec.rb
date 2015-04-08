require 'weapons/bow'

describe Bow do
  let(:bow) { Bow.new }
  describe ':arrows' do
    it 'is accessible' do
      expect(bow).to respond_to(:arrows)
    end
    it 'starts with 10 arrows by default' do
      expect(bow.arrows).to eq(10)
    end
    let(:biggest_quiver) { Bow.new(50) }
    it 'starts with a specified number of arrows when passed as an arg' do
      expect(biggest_quiver.arrows).to eq(50)
    end
    it 'is reduced by 1 when used' do
      bow.use
      expect(bow.arrows).to eq(9)
    end
    it 'throws an error when used at zero' do
      10.times { bow.use }
      expect { bow.use }.to raise_error
    end
  end
end
