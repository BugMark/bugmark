# Offer type
class Types::Exc::OfferType < Types::Base::Object
  field :id,               Int,                  null: true
  field :uuid,             String,               null: true
  field :type,             String,               null: true
  field :stm_issue_uuid,   String,               null: true
  field :stm_tracker_uuid, String,               null: true
  field :stm_title,        String,               null: true
  field :stm_status,       String,               null: true
  field :user_uuid,        String,               null: false
  field :user,             Types::Exc::UserType, null: false
end
