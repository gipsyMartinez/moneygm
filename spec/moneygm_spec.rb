require 'spec_helper'

  describe 'Object instance' do
    context 'when there is not a currency assigned' do
      it 'should assign EUR as a default currency and the right amount value' do
        money_without_currency = Money.new(10)
        expect(money_without_currency.currency).to eq 'EUR'
        expect(money_without_currency.amount).to eq 10
      end
    end
    context 'when there is a currency initialized (USD)' do
      it 'should assign the right attributes values' do
        money_usd = Money.new(20, 'USD')
        usd_conversion_hash = { 'EUR' => 0.90, 'Bitcoin' => 0.00423 }
        expect(money_usd.currency).to eq 'USD'
        expect(money_usd.amount).to eq 20
        expect(money_usd.conversion).to match(usd_conversion_hash)
      end
    end
  end

  describe "#inspect" do
    context 'when Money object is set' do
      it 'should return an string with the right amount and right currency' do
        money = Money.new(5, 'EUR')
        expect(money.inspect).to eq "#{money.amount} #{money.currency}"
      end
    end
  end

  describe "#convert_to" do
    context 'when currency to convert does not exist' do
      it 'should return a copy with the same values of the initial object' do
        money = Money.new(55, 'EUR')
        expect(money.convert_to('BS').amount).to be money.amount
        expect(money.convert_to('BS').currency).to be money.currency
      end
    end
    context 'when currency to convert is the same currency initialized' do
      it 'should return an object with the same currency and amount' do
        money = Money.new(55, 'Bitcoin')
        expect(money.convert_to('Bitcoin').amount).to be money.amount
        expect(money.convert_to('Bitcoin').currency).to be money.currency
      end
    end
    context 'when currency exist and is different to the currency initialized' do
      it 'should return and object with the the converted amount and currency value' do
        money = Money.new(15, 'USD')
        expect(money.convert_to('EUR').amount).to eq 13.5
        expect(money.convert_to('EUR').currency).to eq 'EUR'
      end
    end
  end

  describe "Aritmetic operations" do
    context 'when operator is +' do
      context 'when the two objects have the same currency' do
        it 'should return the addition with the initialized currency' do
          money_one = Money.new(15, 'USD')
          money_two = Money.new(30, 'USD')
          expect(money_one + money_two).to eq "45 USD"
        end
      end
      context 'when the two objects have differents currencies' do
        it 'should convert currencies to EUR and sum the amounts' do
          money_one = Money.new(10, 'EUR')
          money_two = Money.new(5, 'USD')
          expect(money_one + money_two).to eq "14.5 EUR"
        end
      end
    end

    context 'when operator is -' do
      context 'when the two objects have the same currency' do
        it 'should return the susbtraction with the initialized currency' do
          money_one = Money.new(20, 'USD')
          money_two = Money.new(10, 'USD')
          expect(money_one - money_two).to eq "10 USD"
        end
      end
      context 'when the two objects have differents currencies' do
        it 'should convert currencies to EUR and sum the amounts' do
          money_one = Money.new(10, 'EUR')
          money_two = Money.new(5, 'USD')
          expect(money_one - money_two).to eq "5.5 EUR"
        end
      end
    end

    context 'when operator is /' do
      money = Money.new(10, 'EUR')
      it 'should return the divided amount with the initial currency' do
        expect(money/2).to eq '5 EUR'
      end
    end

    context 'when operator is *' do
      money = Money.new(5, 'EUR')
      it 'should return the multiplied amount with the initial currency' do
        expect(money*3).to eq '15 EUR'
      end
    end
  end

  describe  'Comparisons' do
    context 'when operator is ==' do
      context 'whe currencies are the same' do
        it 'should return true or false for each case' do
          money_one = Money.new(5, 'EUR')
          money_two = Money.new(10, 'EUR')
          money_three = Money.new(5, 'EUR')
          expect(money_one == money_two).to be false
          expect(money_one == money_three).to be true
        end
      end
      context 'whe currencies are not the same' do
        it 'should return true or false for each case' do
          money_one = Money.new(9.99, 'EUR')
          money_two = Money.new(11.1, 'USD')
          money_three = Money.new(5, 'EUR')
          expect(money_one == money_two).to be true
          expect(money_one == money_three).to be false
        end
      end
    end

    context 'when operator is > or <' do
      it 'should return true or false for each case' do
        money_one = Money.new(4, 'EUR')
        money_two = Money.new(10, 'EUR')
        money_three = Money.new(5, 'EUR')
        expect(money_one > money_two).to be false
        expect(money_one < money_three).to be true
      end
    end
  end


