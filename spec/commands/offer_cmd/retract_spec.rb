require 'rails_helper'

RSpec.describe OfferCmd::Retract do

  let(:ask)    { FG.create(:buy_fixed).offer                              }
  let(:bid)    { FG.create(:buy_unfixed).offer                              }
  let(:user)   { FG.create(:user).user                                  }
  let(:klas)   { described_class                                        }
  subject      { klas.new(bid)                                          }

  describe "Attributes", USE_VCR do
    it { should respond_to :offer                  } #
  end

  describe "Object Existence", USE_VCR do
    it { should be_a klas   }
    it { should be_valid    }
  end

  describe "Subobjects", USE_VCR do
    it { should respond_to :subobject_symbols }
    it 'returns an array' do
      expect(subject.subobject_symbols).to be_an(Array) #
    end
  end

  describe "Delegated Object", USE_VCR do
    it 'has a present Offer' do
      expect(subject.offer).to be_present
    end

    it 'has a Offer with the right class' do
      expect(subject.offer).to be_a(Offer)
    end

    it 'should have a valid Offer' do
      expect(subject.offer).to be_valid
    end
  end

  describe "#event_data", USE_VCR do
    it 'returns a hash' do
      expect(subject.event_data).to be_a(Hash)
    end

    it 'has expected hash keys' do
      keys = subject.event_data.keys
      expect(keys).to include("id")
    end
  end

  describe "#project", USE_VCR do
    it 'saves the object to the database' do
      subject.project
      expect(subject).to be_valid
    end

    it 'gets the right object count' do
      hydrate(bid)
      expect(Offer.count).to eq(1)
      expect(Offer.open.count).to eq(1)
      expect(Offer.retracted.count).to eq(0)
      subject.project
      expect(Offer.count).to eq(1)
      expect(Offer.open.count).to eq(0)
      expect(Offer.retracted.count).to eq(1)
    end
  end

  describe "#event_save", USE_VCR do
    it 'creates an event' do
      expect(EventLine.count).to eq(0)
      subject.save_event
      expect(EventLine.count).to eq(5)
    end

    it 'chains with #project' do
      expect(EventLine.count).to eq(0)
      expect(Offer.count).to eq(0)
      subject.save_event.project
      expect(EventLine.count).to eq(5)
      expect(Offer.count).to eq(1)
    end
  end
end


