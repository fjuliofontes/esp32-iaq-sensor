#ifndef WIFI_PROV_H_
#define WIFI_PROV_H_

void wifi_prov_init(void);

int wifi_start_sta(void);

void wifi_stop_sta(void);

int wifi_unprovision(void);

#endif