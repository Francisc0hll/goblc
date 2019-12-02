class MatchOnCardTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :match_on_card_transactions do |t|
      t.json :event_json
      t.references :totem
      t.timestamps
    end
  end
end
