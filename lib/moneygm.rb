class Money
  attr_accessor  :amount, :currency, :conversion
  def initialize(amount, currency = nil)
    @amount = amount
    @currency = currency || "EUR" #Si no hay moneda definida, la default es EUR
    @conversion = { 'USD' => 1.11, 'Bitcoin' => 0.0047 } if @currency == "EUR"
    @conversion = { 'EUR' => 0.90, 'Bitcoin' => 0.00423 } if @currency == "USD"
    @conversion = { 'EUR' => 212.76, 'USD' => 236.16 } if @currency == "Bitcoin"
  end

  def inspect
    "#{@amount} #{@currency}"
  end

  # Retorna una copia del objeto con la conversion solicitada, si la moneda no existe retorna el obj inicial
  def convert_to(currency_to_convert)
    obj_copy = self.dup #copio el objeto
    return obj_copy if self.conversion[currency_to_convert].nil? || currency_to_convert == self.currency
    obj_copy.amount = (obj_copy.amount * obj_copy.conversion[currency_to_convert]).round(2)
    obj_copy.currency = currency_to_convert
    return obj_copy
  end

  # OPERACIONES ARITMETICAS

  # Para la suma y la resta se asume que siempre seran dos objetos de tipo Money y que si las
  # monedas son diferentes la conversion se hara a EUR
  def + (object_to_add)
    if self.currency == object_to_add.currency
      value = self.amount + object_to_add.amount
      "#{value} #{self.currency}"
    else
      value = self.convert_to('EUR').amount + object_to_add.convert_to('EUR').amount
      "#{value} EUR"
    end
  end

  def - (obj_to_substract)
    if self.currency == obj_to_substract.currency
      value = self.amount - obj_to_substract.amount
      # se coloca el valor absoluto (value.abs) ya que si restas dos monedas (ej 2 billetes) no queda un saldo negativo, sin importar el orden de los factores
      "#{value.abs} #{self.currency}"
    else
      value = self.convert_to('EUR').amount - obj_to_substract.convert_to('EUR').amount
      "#{value.abs} EUR"
    end
  end

  # Para la multiplicacion y la division se asume que los parametros seran valores numericos
  # y no un objeto
  def * (multiplier)
    value = self.amount * multiplier
    "#{value} #{self.currency}"
  end

  def / (divider)
    value = self.amount / divider
    "#{value} #{self.currency}"
  end

  # COMPARACIONES

  # Solo se consideran los operadores == , >, <
  def == (obj)
    self.convert_to('EUR').amount == obj.convert_to('EUR').amount ? true : false
  end

  def > (obj)
    self.convert_to('EUR').amount > obj.convert_to('EUR').amount ? true : false
  end

  def < (obj)
    self.convert_to('EUR').amount < obj.convert_to('EUR').amount ? true : false
  end
end

