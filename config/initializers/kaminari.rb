Kaminari::Hooks.init if defined?(Kaminari::Hooks)
kaminari = Elasticsearch::Model::Response::Pagination::Kaminari
Elasticsearch::Model::Response::Response.__send__ :include, kaminari
