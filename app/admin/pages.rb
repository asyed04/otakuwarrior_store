ActiveAdmin.register Page do
  permit_params :title, :content, :slug

  form do |f|
    f.inputs do
      f.input :title
      f.input :slug, hint: "Use 'about' or 'contact'"
      f.input :content, as: :text
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :title
    column :slug
    actions
  end
end
