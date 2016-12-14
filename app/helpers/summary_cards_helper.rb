module SummaryCardsHelper
  def summary_card_for(resource)
    {
      Group => 'shared/summary_cards/group',
      GroupsUser => 'shared/summary_cards/member',
      List => 'shared/summary_cards/list',
      Resource => 'shared/summary_cards/resource',
    }[resource.class]
  end
end
