require 'viking'

describe Viking do
  let(:default_viking) { Viking.new }
  describe '#initialize' do
    let(:thjodolf) { Viking.new('Thjodolf') }
    it 'has a name attribute of whatever is passed' do
      expect(thjodolf.name).to eq('Thjodolf')
    end
    let(:sickly_nord) { Viking.new('Bjorn', 20) }
    it 'has a health attribute of whatever is passed' do
      expect(sickly_nord.health).to eq(20)
    end
    it 'cannot change health after being initialized' do
      expect { sickly_nord.health = 10 }.to raise_error
    end
    it 'starts with a nil weapon by default' do
      expect(default_viking.weapon).to eq(nil)
    end
  end
  describe '#pick_up_weapon' do
    it 'sets the weapon attribute when picked up' do
      default_viking.pick_up_weapon(Axe.new)
      expect(default_viking.weapon).to be_a_kind_of(Weapon)
    end
    it 'raises an exception when picking up a non-weapon' do
      expect { default_viking.pick_up_weapon(Viking.new) }.to raise_error
    end
    it 'replaces an existing weapon if a new one is picked up' do
      default_viking.pick_up_weapon(Axe.new)
      default_viking.pick_up_weapon(Bow.new)
      expect(default_viking.weapon).to be_a(Bow)
    end
  end
  describe '#drop_weapon' do
    it 'leaves the viking weaponless' do
      default_viking.pick_up_weapon(Axe.new)
      default_viking.drop_weapon
      expect(default_viking.weapon).to eq(nil)
    end
  end
  describe '#receive_attack' do
    it "reduces a viking's health by a specified amount" do
      default_viking.receive_attack(10)
      expect(default_viking.health).to eq(90)
    end
    it 'receives the take_damage method call' do
      expect(default_viking).to receive(:take_damage)
      default_viking.receive_attack(10)
    end
  end
  describe '#attack' do
    let(:thunvir) { Viking.new('Thunvir') }
    it 'causes the recipients health to drop' do
      thunvir.attack(default_viking)
      expect(default_viking.health).to be < 100
    end
    it "calls recipient viking's take_damage method" do
      expect(default_viking).to receive(:take_damage)
      thunvir.attack(default_viking)
    end
    it 'uses fists when viking is not holding a weapon' do
      allow(thunvir).to receive(:damage_with_fists).and_return(2.5)
      expect(thunvir).to receive(:damage_with_fists)
      thunvir.attack(default_viking)
    end
    it 'uses fists multiplier times strength to determine damage when
      attacking with no weapon' do
      thunvir.attack(default_viking)
      expect(default_viking.health).to eq(100 - (Fists.new.use *
        thunvir.strength))
    end
    it "deals damage equal to the Viking's strength times that Weapon's
      multiplier" do
      thunvir.pick_up_weapon(Axe.new)
      thunvir.attack(default_viking)
      expect(default_viking.health).to eq(100 - (Axe.new.use *
        thunvir.strength))
    end
    it 'attacks with fists if trying to attack with bow without arrows' do
      allow(thunvir).to receive(:damage_with_fists).and_return(2.5)
      expect(thunvir).to receive(:damage_with_fists)
      thunvir.pick_up_weapon(Bow.new(0))
      thunvir.attack(default_viking)
    end
  end
  describe '#check_death' do
    let(:martyr) { Viking.new('Marty the Martyr', 2.5) }
    it 'raises an error' do
      expect { default_viking.attack(martyr) }.to raise_error
    end
  end
end
