const initTabs = () => {
  const tabs = document.querySelector('.tabs');

  const changeTabHeight = () => {

  };

  if (tabs) {
    M.Tabs.init(tabs, {
      swipeable: true,
      onShow: (tab) => {
        let height = 0;
        if (tab.children[0]) {
          height = tab.children[0].scrollHeight + 20;
        }
        document.querySelector(".tabs-content").style.height = height + 'px';
        console.log(tab.id);
        if (tab.id != 'itineraries') {
          document.querySelector('.sticky-cta').classList.add('hide-cta');
        } else { document.querySelector('.sticky-cta').classList.remove('hide-cta') }
      }
    });
    window.addEventListener('resize', function(event) {
          const tab = document.querySelector(".carousel-item.active");
          const tabsContent = document.querySelector(".tabs-content");
          let height = 0;
          if (tab.children[0]) {
            height = tab.children[0].scrollHeight + 20;
          }
          tabsContent.style.height = height + 'px';
          location.reload(true);
    });
  };

};

export default initTabs;
