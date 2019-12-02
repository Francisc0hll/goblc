# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
institution = Institution.create!(name: "Ministerio del Test")
AdminUser.create!(
  email: 'admin1@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin_type: 'super_admin',
  institution_id: institution.id)

Procedure.create!(
  name: "Certificado de Situación Militar",
  price: nil,
  active_in_totem: true,
  security: "authentication",
  type_of_procedure: "simple",
  description: " Consiste en certificado de situacion militar ",
  info: "",
  warning: "",
  id_proceso_simple: 1856,
  id_etapa_simple: nil,
  class_name_simple: "ProcedureCertificadoSituacionMilitar",
  chile_atiende_id: 946,
  institution_id: institution.id,
  category: "",
  subcategory: ""
)
Procedure.create!(
  name: "Certificado de constancia de pensionado",
  price: nil,
  active_in_totem: true,
  security: "authentication",
  type_of_procedure: "simple",
  description: "Consiste en certificado de si eres o no pensionado",
  info: "",
  warning: "",
  id_proceso_simple: 5,
  id_etapa_simple: 8,
  class_name_simple: "ProcedureConstanciaDePensionado",
  chile_atiende_id: nil,
  institution_id: institution.id,
  category: "",
  subcategory: ""
)
Procedure.create!(
  name: "Certificado de declaración de renta",
  price: nil,
  active_in_totem: true,
  security: "authentication",
  type_of_procedure: "simple",
  description: "Consiste en certificado de la declaración de renta para un periodo",
  info: "",
  warning: "",
  id_proceso_simple: 11,
  id_etapa_simple: 18,
  class_name_simple: "ProcedureDeclaracionDeRenta",
  chile_atiende_id: nil,
  institution_id: institution.id,
  category: "",
  subcategory: ""
)
Procedure.create!(
  name: "Certificado de Nacimiento",
  price: nil,
  active_in_totem: true,
  security: "authentication",
  type_of_procedure: "simple",
  description: "Consiste en certificado de nacimiento",
  info: "",
  warning: "",
  id_proceso_simple: 40,
  id_etapa_simple: 53,
  class_name_simple: "ProcedureCertificadoNacimiento",
  chile_atiende_id: nil,
  institution_id: institution.id,
  category: "",
  subcategory: ""
)

Procedure.create!(
  name: "Certificado de Matrimonio",
  price: nil,
  active_in_totem: true,
  security: "authentication",
  type_of_procedure: "simple",
  description: "Consiste en certificado de matrimonio",
  info: "",
  warning: "",
  id_proceso_simple: 39,
  id_etapa_simple: 52,
  class_name_simple: "ProcedureCertificadoMatrimonio",
  chile_atiende_id: nil,
  institution_id: institution.id,
  category: "",
  subcategory: ""
)

Procedure.create!(
  name: "Certificado de defuncion",
  price: nil,
  active_in_totem: true,
  security: "authentication",
  type_of_procedure: "simple",
  description: "Consiste en certificado de defuncion",
  info: "",
  warning: "",
  id_proceso_simple: 38,
  id_etapa_simple: 51,
  class_name_simple: "ProcedureCertificadoDefuncion",
  chile_atiende_id: nil,
  institution_id: institution.id,
  category: "",
  subcategory: ""
)

Procedure.create!(
  name: "Certificado de Cotizacion de Fonasa",
  price: nil,
  active_in_totem: true,
  security: "authentication",
  type_of_procedure: "simple",
  description: "Consiste en certificado de cotizaciones de Fonasa",
  info: "",
  warning: "",
  id_proceso_simple: 32,
  id_etapa_simple: 45,
  class_name_simple: "ProcedureCertificadoCotizacionFonasa",
  chile_atiende_id: nil,
  institution_id: institution.id,
  category: "",
  subcategory: ""
)