module SummaryCardsHelper
  def summary_card_for(resource)
    {
      'Network' => 'shared/summary_cards/network',
      'NetworksUser' => 'shared/summary_cards/member',
      'List' => 'shared/summary_cards/list',
      'Resource' => 'shared/summary_cards/resource',
    }[resource.class.to_s]
  end
end
