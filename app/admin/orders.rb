ActiveAdmin.register Order do
  permit_params :customer_id, :total, :gst, :pst, :hst, :payment_id, :status

  index do
    selectable_column
    id_column
    column :customer
    column :total
    column :gst
    column :pst
    column :hst
    column :payment_id
    column :status do |order|
      status_tag order.status,
                 class: case order.status
                        when 'cancelled'
                          'error'
                        when 'paid'
                          'success'
                        else
                          order.status == 'delivered' ? 'completed' : 'in_progress'
                        end
    end
    column :created_at
    actions
  end

  filter :payment_id
  filter :customer
  filter :status, as: :select, collection: Order::STATUSES.values
  filter :created_at

  show do
    attributes_table do
      row :id
      row :customer
      row :total
      row :gst
      row :pst
      row :hst
      row :payment_id
      row :status do |order|
        status_tag order.status,
                   class: case order.status
                          when 'cancelled'
                            'error'
                          when 'paid'
                            'success'
                          else
                            order.status == 'delivered' ? 'completed' : 'in_progress'
                          end
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :customer
      f.input :total
      f.input :gst
      f.input :pst
      f.input :hst
      f.input :payment_id
      f.input :status, as: :select, collection: Order::STATUSES.values
    end
    f.actions
  end
end
