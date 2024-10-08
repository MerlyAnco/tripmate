class Plan < ApplicationRecord
  belongs_to :user
  has_many :travels, dependent: :destroy
  has_many_attached :photos
  has_many :messages
  has_one_attached :photo

  DEPARTAMENTS = [
    'Amazonas', 'Áncash', 'Apurímac', 'Arequipa', 'Ayacucho', 'Cajamarca',
    'Callao', 'Cusco', 'Huancavelica', 'Huánuco', 'Ica', 'Junín', 'La Libertad',
    'Lambayeque', 'Lima', 'Loreto', 'Madre de Dios', 'Moquegua', 'Pasco', 'Piura',
    'Puno', 'San Martín', 'Tacna', 'Tumbes', 'Ucayali'
  ]

  geocoded_by :start_point
  after_validation :geocode, if: :will_save_change_to_start_point?

  validates :name, :description, :location, :travelers_quantity, :start_date, :end_date, :start_point, presence: true
  validates :departament, inclusion: { in: DEPARTAMENTS, message: "%{value} no es un departamento válido" }
  validate :start_date_cannot_be_in_the_past
  validate :end_date_cannot_be_in_the_past

  private

  def start_date_cannot_be_in_the_past
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "No puede ser en el pasado")
    end
  end

  def end_date_cannot_be_in_the_past
    if end_date.present? && end_date < Date.today && end_date < start_date
      errors.add(:end_date, "La fecha de retorno no puede ser antes del inicio")
    end
  end
end
