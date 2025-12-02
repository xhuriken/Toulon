using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Headbob : MonoBehaviour
{
    [Header("Configuration")]
    [SerializeField] private bool _enable = true;
    [SerializeField, Range(0, 0.1f)] private float _Amplitude = 0.015f;
    [SerializeField, Range(0, 30)] private float _frequency = 10.0f;
    [SerializeField] private Transform _camera = null;
    [SerializeField] private Transform _cameraHolder = null;

    [Header("Hammer (optionnel)")]
    [SerializeField] private Transform _hammer = null;
    [SerializeField] private float hammerMultiplier = 1.5f; 

    private float _toggleSpeed = 3.0f;
    private Vector3 _startPos;
    private Vector3 _hammerStartPos;
    private PlayerMovement _controller;

    private void Awake()
    {
        _controller = GetComponent<PlayerMovement>();
        _startPos = _camera.localPosition;

        if (_hammer != null)
            _hammerStartPos = _hammer.localPosition;
    }

    void Update()
    {
        if (!_enable) return;

        CheckMotion();
        ResetPosition();

        _camera.LookAt(FocusTarget());
    }

    private Vector3 FootStepMotion()
    {
        Vector3 pos = Vector3.zero;

        pos.y += Mathf.Sin(Time.time * _frequency) * _Amplitude;
        pos.x += Mathf.Cos(Time.time * _frequency / 2) * _Amplitude * 2;

        return pos;
    }

    private void CheckMotion()
    {
        float speed = new Vector3(_controller.rb.velocity.x, 0, _controller.rb.velocity.z).magnitude;
        if (speed < _toggleSpeed) return;
        if (!_controller.grounded) return;

        Vector3 motion = FootStepMotion();
        PlayMotion(motion);
        PlayHammerMotion(motion);
    }

    private void PlayMotion(Vector3 motion)
    {
        _camera.localPosition += motion;
    }

    private void PlayHammerMotion(Vector3 motion)
    {
        if (_hammer == null) return;

     
        _hammer.localPosition += motion * hammerMultiplier;
    }

    private Vector3 FocusTarget()
    {
        Vector3 pos = new Vector3(transform.position.x, transform.position.y + _cameraHolder.localPosition.y, transform.position.z);
        pos += _cameraHolder.forward * 15.0f;
        return pos;
    }

    private void ResetPosition()
    {
       
        if (_camera.localPosition != _startPos)
        {
            _camera.localPosition = Vector3.Lerp(_camera.localPosition, _startPos, 1 * Time.deltaTime);
        }

      
        if (_hammer != null && _hammer.localPosition != _hammerStartPos)
        {
            _hammer.localPosition = Vector3.Lerp(_hammer.localPosition, _hammerStartPos, 4 * Time.deltaTime);
        }
    }
}
