// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

window.jQuery = $
window.$ = $
window.Routes = require('routes.js.erb')

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")
require("bootstrap")
require("bootstrap-datepicker")
require("bootstrap4-tagsinput/tagsinput")
require("slick-carousel")
require("@nathanvda/cocoon")
require("daterangepicker/daterangepicker")
require("icheck/icheck")


import I18n from 'i18n-js/index.js.erb'
import * as moment from 'moment'
import * as lodash from 'lodash'
import * as bootbox from 'bootbox'
import 'select2'

import appMessages from './components/app_messages';
import Layout from './components/layouts';
import LocationSelect from './components/location_select';
import UpdateBookingStatus from './components/update_booking_status';
import DeeplTranslation from './pages/admin/deepl_translation';

import AdminUser from './pages/admin_user';
import AdminCampsiteBookings from './pages/admin/campsite_bookings';
import AdminCampCarBookings from './pages/admin/camp_car_bookings';
import AdminCampsite from './pages/admin/campsite'
import AdminCampsitePlans from './pages/admin/campsite_plans'
import AdminDateSettings from './pages/admin/date_settings'
import AdminCampCars from './pages/admin/camp_cars';
import AdminBlogs from './pages/admin/blogs';
import AdminCampCarSaleManagements from './pages/admin/camp_car_sale_managements';

import Home from './pages/home';
import CampsitePlans from './pages/campsite_plans';
import CheckoutCampsiteBookings from './pages/checkout/campsite_bookings';
import CheckoutCampCarBookings from './pages/checkout/camp_car_bookings';
import CampsiteDetail from './pages/campsite_detail';
import CampsiteSearch from './components/campsite_search';
import CampCarSearch from './components/camp_car_search';
import CampCarDetail from './pages/camp_car_detail';
import TourDetail from './pages/tour_detail';
import MyPage from './pages/my_page';

window.moment = moment;
window.lodash = lodash;
window.bootbox = bootbox;
window.I18n = I18n

window.appMessages = appMessages

$(() => {
  const bodyData = $('body').data();

  // common
  const layout = new Layout();
  layout.bindEvents();

  const locationSelect = new LocationSelect();
  locationSelect.bindEvents();

  const updateBookingStatus = new UpdateBookingStatus();
  updateBookingStatus.bindEvents();


  // on the admin side
  if (bodyData.page == 'admin') {
    const deeplTranslation = new DeeplTranslation();
    deeplTranslation.bindEvents()

    const adminUser = new AdminUser()
    if (bodyData.controller == 'admin_users') {
      adminUser.bindEvents()
    }

    const adminCampsitePlans = new AdminCampsitePlans();
    if (bodyData.controller == 'campsite_plans'){
      adminCampsitePlans.bindEvents()
    }

    const adminCampsite = new AdminCampsite()
    if (bodyData.controller == 'campsites') {
      adminCampsite.bindEvents()
    }

    const adminDateSettings = new AdminDateSettings()
    if (bodyData.controller == 'date_settings') {
      adminDateSettings.bindEvents()
    }

    const adminCampsiteBookings = new AdminCampsiteBookings()
    if (bodyData.controller == 'campsite_bookings') {
      adminCampsiteBookings.bindEvents()
    }

    const adminCampCarBookings = new AdminCampCarBookings()
    if (bodyData.controller == 'camp_car_bookings') {
      adminCampCarBookings.bindEvents()
    }

    const adminCampCars = new AdminCampCars();
    if (bodyData.controller == 'camp_cars'){
      adminCampCars.bindEvents()
    }

    const adminBlogs = new AdminBlogs();
    if (bodyData.controller == 'blogs'){
      adminBlogs.bindEvents()
    }

    const adminCampCarSaleManagements = new AdminCampCarSaleManagements();
    if (bodyData.controller == 'camp_car_sale_managements'){
      adminCampCarSaleManagements.bindEvents()
    }

    // on the customer side
  } else {

    const home = new Home();
    if (bodyData.controller == 'home' && bodyData.action == 'index'){
      home.initSlider()
    }

    const campsiteDetail = new CampsiteDetail()
    if (bodyData.controller == 'campsites' && bodyData.action == 'show') {
      campsiteDetail.bindEvents()
    }

    const campsitePlans = new CampsitePlans();
    if (bodyData.controller == 'campsite_plans'){
      campsitePlans.bindEvents()
    }

    const campsiteSearch = new CampsiteSearch()
    if (bodyData.controller == 'campsites' && (bodyData.action == 'index' || bodyData.action == 'search')) {
      campsiteSearch.bindEvents()
    }

    const checkoutCampsiteBooking = new CheckoutCampsiteBookings()
    if (bodyData.controller == 'campsite_bookings') {
      checkoutCampsiteBooking.bindEvents()
    }

    const campCarSearch = new CampCarSearch()
    if (bodyData.controller == 'camp_cars' && (bodyData.action == 'index' || bodyData.action == 'search')) {
      campCarSearch.bindEvents()
    }

    const campCarDetail = new CampCarDetail()
    if (bodyData.controller == 'camp_cars' && (bodyData.action == 'show')) {
      campCarDetail.bindEvents()
    }

    const checkoutCampCarBooking = new CheckoutCampCarBookings()
    if (bodyData.controller == 'camp_car_bookings') {
      checkoutCampCarBooking.bindEvents()
    }

    const tourDetail = new TourDetail()
    if (bodyData.controller == 'tours' && bodyData.action == 'show') {
      tourDetail.initSlider()
    }

    const myPage = new MyPage()
    if (bodyData.controller == 'my_pages' && bodyData.action == 'show') {
      myPage.bindEvents()
    }

  }


  $('[data-toggle="popover"]').popover()
})
