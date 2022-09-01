# frozen_string_literal: true

json.task do
  json.id @task.id
  json.slug @task.slug
  json.title @task.title

  json.assigned_user do
    json.id @task.assigned_user.id
    json.name @task.assigned_user.name
  end
end
