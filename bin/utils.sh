# !/bin/bash
. "$APP_HOME/libexec/log.sh"

# import jaas file
function jaas() {
    if [[ -f $JAAS_PATH ]]; then
        log_info "Starting export JAAS..." |& tee -a ${LOG_PATH}
        export KAFKA_OPTS="-Djava.security.auth.login.config=$JAAS_PATH"
    else
        log_error "JAAS file is not in the file." |& tee -a ${LOG_PATH}
    fi
}

function kill_process() {
    if [[ -n "$PID" ]]; then
        KILL_PID=`kill -9 $PID`
        log_info "Stopping service: $1" |& tee -a ${LOG_PATH}
    fi
}

function get_withoutssl_pid() {
    PID=`ps aux | grep ${TOPICS} | grep -v grep | awk '{print $2}'`
}

function get_ssl_pid() {
    PID=`ps aux | grep ${TOPICS_SSL} | grep -v grep | awk '{print $2}'`
}

function get_status() {
    if [[ -n "$PID" ]]; then
        log_info "Status Running: $1" |& tee -a ${LOG_PATH}
    else
        log_info "Status Stopped: $1" |& tee -a ${LOG_PATH}
    fi
}

function start_nossl() {
    log_info "Starting service: nossl" |& tee -a ${LOG_PATH}
    nohup kafka-run-class kafka.tools.MirrorMaker --consumer.config ${CONSUMER_PATH} --producer.config ${PRODUCER_PATH} --whitelist ${TOPICS} --new.consumer > /dev/null 2>&1 &
}

function start_ssl() {
    log_info "Starting service: ssl" |& tee -a ${LOG_PATH}
    nohup kafka-run-class kafka.tools.MirrorMaker --consumer.config ${CONSUMER_PATH_SSL} --producer.config ${PRODUCER_PATH} --whitelist ${TOPICS_SSL} --new.consumer > /dev/null 2>&1 &
}