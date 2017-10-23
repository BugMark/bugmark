require 'rails_helper'

RSpec.describe Amendment::Transfer, type: :model do

  def valid_params() {} end

  def soff_params
    {
      parent_position: ppos    ,
      user:            user
    }
  end

  def position_params(opts = {})
    {
      user:      user       ,
      buy_offer: boff       ,
    }.merge(opts)
  end

  def megatran
    klas.create({
      sell_offer:        soff     ,
      buy_offer:         boff     ,
      parent_position:   ppos     ,
      seller_position:   spos     ,
      buyer_position:    bpos     ,
    })
  end

  let(:user)   { FG.create(:user).user                        }
  let(:ppos)   { Position.create(position_params)             }
  let(:spos)   { Position.create(position_params)             }
  let(:bpos)   { Position.create(position_params)             }
  let(:boff)   { FG.create(:buy_bid, user_id: user.id).offer  }
  let(:soff)   { Offer::Sell::Bid.create(soff_params)         }
  let(:tran)   { megatran                                     }

  let(:klas)   { described_class                              }
  subject      { klas.new(valid_params)                       }

  describe "Associations", USE_VCR do
    it { should respond_to(:sell_offer)            }
    it { should respond_to(:buy_offer)             }
    it { should respond_to(:parent_position)       }
    it { should respond_to(:seller_position)       }
    it { should respond_to(:buyer_position)        }
  end

  describe "Object Creation", USE_VCR do
    it { should be_valid }

    it 'saves the object to the database' do
      subject.save
      expect(subject).to be_valid
    end
  end

  describe "Associations", USE_VCR do
    before(:each) do hydrate(tran) end

    it "finds the sell offer" do
      expect(tran.sell_offer).to eq(soff)
    end

    it "finds the buy offer" do
      expect(tran.buy_offer).to eq(boff)
    end

    it "finds the parent_position" do
      expect(tran.parent_position).to eq(ppos)
    end

    it "finds the buyer_position" do
      expect(tran.buyer_position).to eq(bpos)
    end

    it "finds the seller_position" do
      expect(tran.seller_position).to eq(spos)
    end
  end
end

# == Schema Information
#
# Table name: amendments
#
#  id                     :integer          not null, primary key
#  type                   :string
#  sequence               :integer
#  contract_id            :integer
#  exp_sell_bid_id        :integer
#  exp_buy_bid_id         :integer
#  exp_sell_ask_id        :integer
#  exp_buy_ask_id         :integer
#  exp_resell_bid_id      :integer
#  exp_rebuy_bid_id       :integer
#  exp_resell_ask_id      :integer
#  exp_rebuy_ask_id       :integer
#  exp_bid_position_id    :integer
#  exp_ask_position_id    :integer
#  exp_escrow_id          :integer
#  trn_sell_offer_id      :integer
#  trn_buy_offer_id       :integer
#  trn_parent_position_id :integer
#  trn_seller_position_id :integer
#  trn_buyer_position_id  :integer
#  red_escrow_id          :integer
#  res_escrow_id          :integer
#  xfields                :hstore           not null
#  jfields                :jsonb            not null
#  exref                  :string
#  uuref                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
