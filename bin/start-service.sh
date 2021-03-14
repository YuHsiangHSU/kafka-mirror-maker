#!/bin/sh
export APP_HOME="$(cd "`dirname "$0"`"/..; pwd)"
LOG_PATH=$APP_HOME/var/logs/job.log
. "$APP_HOME/libexec/log.sh"
ENV=${1}
ACTION=${2}
SERVICE=${3}

function usage() {
    echo "
    EXAMPLES:
        sh bin/start-service.sh ut start all
    COMMANDS:
        1) First variable records env
            ut       ip 123.456.789
            uat      ip 123.456.789
            prod     ip 123.456.789
        2) Second variable records action
            start    start kafka_mirror_maker
            stop     stop kafka_mirror_maker
            restart  restart kafka_mirror_maker
            status   check kafka_mirror_maker is running
        3) Third variable records service
            all      all service (ssl/nossl)
            ssl      service with ssl
            nossl    service without ssl
    "
}

if [[ -z ${ENV} ]] || [[ -z ${ACTION} ]] || [[ -z ${SERVICE} ]]; then
    log_error "$(basename $0): missing parameter " |& tee -a ${LOG_PATH}
    usage
    exit 1
fi

# import config
JAAS_PATH=$APP_HOME/conf/${ENV}/jaas.conf
CONSUMER_PATH=$APP_HOME/conf/${ENV}/consumer.properties
CONSUMER_PATH_SSL=$APP_HOME/conf/${ENV}/consumer_ssl.properties
PRODUCER_PATH=$APP_HOME/conf/${ENV}/producer.properties
. "$APP_HOME/bin/utils.sh"
. "$APP_HOME/conf/${ENV}/topic_list.properties"

# check $ACTION variable
case ${ACTION} in
    start)
        jaas
        case ${SERVICE} in
        all)
            start_ssl
            start_nossl
            exit ;;
        ssl)
            start_ssl
            exit ;;
        nossl)
            start_nossl
            exit ;;
        *)
            log_error "START action has wrong service type, please type all/ssl/nossl" |& tee -a ${LOG_PATH}
            usage
            exit;;
        esac ;;
    status)
        case ${SERVICE} in
        all)
            get_ssl_pid
            get_status ssl
            get_withoutssl_pid
            get_status nossl
            exit ;;
        ssl)
            get_ssl_pid
            get_status ssl
            exit ;;
        nossl)
            get_withoutssl_pid
            get_status nossl
            exit ;;
        *)
            log_error "STATUS action has wrong service type, please type all/ssl/nossl" |& tee -a ${LOG_PATH}
            usage
            exit;;
        esac ;;
    stop)
        case ${SERVICE} in
        all)
            get_ssl_pid
            kill_process ssl
            get_withoutssl_pid
            kill_process nossl
            exit ;;
        ssl)
            get_ssl_pid
            kill_process ssl
            exit ;;
        nossl)
            get_withoutssl_pid
            kill_process nossl
            exit ;;
        *)
            log_error "STOP action has wrong service type, please type all/ssl/nossl" |& tee -a ${LOG_PATH}
            usage
            exit;;
        esac ;;
    restart)
        case ${SERVICE} in
        all)
            STOP=`sh bin/start-service.sh ut stop ssl`
            START=`sh bin/start-service.sh ut start ssl`
            echo $STOP $START
            STOP=`sh bin/start-service.sh ut stop nossl`
            START=`sh bin/start-service.sh ut start nossl`
            echo $STOP $START
            exit ;;
        ssl)
            STOP=`sh bin/start-service.sh ut stop ssl`
            START=`sh bin/start-service.sh ut start ssl`
            echo $STOP $START
            exit ;;
        nossl)
            STOP=`sh bin/start-service.sh ut stop nossl`
            START=`sh bin/start-service.sh ut start nossl`
            echo $STOP $START
            exit ;;
        *)
            log_error "RESTART action has wrong service type, please type all/ssl/nossl" |& tee -a ${LOG_PATH}
            usage
            exit;;
        esac ;;
    *)
        log_error "Action type is wrong , please type start/stop/status/restart" |& tee -a ${LOG_PATH}
        usage
        exit ;;
esac
